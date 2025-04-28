import yfinance as yf
import pandas as pd
import time
from datetime import datetime, timedelta
import pyodbc
import logging
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.timetables.interval import CronDataIntervalTimetable

# Setup logging
logging.basicConfig(level=logging.INFO)
success_logger = logging.getLogger("success")
error_logger = logging.getLogger("error")

# --- Constants ---
SP500_URL = 'https://en.wikipedia.org/wiki/List_of_S%26P_500_companies'
FINAL_TABLE = "stock_prices"

# --- SQL Utilities ---
def create_connection():
    # conn_str = (
    #     r"DRIVER={SQL Server};"
    #     r"SERVER=LAPTOP-NEEIVGK7\MSSQLSERVER1;"
    #     r"DATABASE=BikeStores;"
    #     r"Trusted_Connection=yes;"
    # )

    conn_str = (
        r"DRIVER={ODBC Driver 18 for SQL Server};"
        r"SERVER=192.168.0.107\MSSQLSERVER1;"
        r"DATABASE=BikeStores;"
        r"UID=test;"
        r"PWD=Test123*;"
        r"TrustServerCertificate=yes;"
        r"Timeout=30;"

    )


    try:
        return pyodbc.connect(conn_str)
    except Exception as e:
        error_logger.error(f"SQL connection error: {e}")
        return None

def create_table_if_not_exists():
    conn = create_connection()
    if not conn:
        return
    cursor = conn.cursor()
    query = """
    IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='stock_prices' and xtype='U')
    CREATE TABLE stock_prices (
        trade_date DATETIME,
        close_price FLOAT,
        high_price FLOAT,
        low_price FLOAT,
        open_price FLOAT,
        volume BIGINT,
        symbol VARCHAR(10),
        close_change FLOAT,
        close_pct_change FLOAT
    )
    """
    cursor.execute(query)
    conn.commit()
    cursor.close()
    conn.close()

def insert_data_to_db(values):
    conn = create_connection()
    if not conn:
        return
    cursor = conn.cursor()
    query = f"""
    INSERT INTO {FINAL_TABLE} (
        trade_date, close_price, high_price, low_price, open_price,
        volume, symbol, close_change, close_pct_change
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"""
    cursor.executemany(query, values)
    conn.commit()
    cursor.close()
    conn.close()

# --- Data Pipeline Functions ---
def get_sp500_tickers():
    tables = pd.read_html(SP500_URL)
    return tables[0]['Symbol'][:10].tolist()

def fetch_yfinance_data(symbols, start_date, end_date, interval):
    results = {}
    for symbol in symbols:
        try:
            df = yf.download(
                tickers=symbol,
                start=start_date,
                end=end_date,
                interval=interval,
                progress=False,
                ignore_tz=True
            )
            if not df.empty:
                results[symbol] = df
        except Exception as e:
            error_logger.error(f"{symbol} fetch error: {e}")
    return results

def transform_data(df, symbol):
    df.columns = [col[0] for col in df.columns]
    df = df.reset_index()
    print(df)
    # df = df[df["Close"] != 0]
    df["symbol"] = symbol
    df['close_change'] = df['Close'].diff().fillna(0)
    df['close_pct_change'] = df['Close'].pct_change().fillna(0) * 100
    return df[['Date', 'Close', 'High', 'Low', 'Open', 'Volume', 'symbol', 'close_change', 'close_pct_change']]

# --- Airflow Tasks ---
def get_symbols_task(**kwargs):
    symbols = get_sp500_tickers()
    kwargs['ti'].xcom_push(key='symbols', value=symbols[:5])  # Limit to 5 for demo

def fetch_data_task(interval, **kwargs):
    ti = kwargs['ti']
    symbols = ti.xcom_pull(task_ids='get_symbols', key='symbols')
    start_date = (datetime.now() - timedelta(days=7)).strftime('%Y-%m-%d')
    end_date = datetime.now().strftime('%Y-%m-%d')
    symbol_data = fetch_yfinance_data(symbols, start_date, end_date, interval)
    ti.xcom_push(key='fetched_data', value=list(symbol_data.keys()))
    # Save each symbol's data to file for safe XCom

    for symbol, df in symbol_data.items():
        transformed = transform_data(df, symbol)
        transformed.to_csv(f'/tmp/{symbol}.csv')

def transform_and_store_task(**kwargs):
    ti = kwargs['ti']
    print("Third task")
    symbols = ti.xcom_pull(task_ids='fetch_data', key='fetched_data')
    print(symbols)
    # create_table_if_not_exists()
    values = []
    for symbol in symbols:
        try:
            df = pd.read_csv(f'/tmp/{symbol}.csv')
            # transformed = transform_data(df, symbol)
            print(df)

            values.extend([tuple(row) for row in df.to_numpy()])
        except Exception as e:
            error_logger.error(f"{symbol} transform/load error: {e}")
    if values:
        print(values)
        # insert_data_to_db(values)
        success_logger.info(f"Inserted {len(values)} rows.")

# --- Airflow DAG Definition ---
default_args = {  
    "owner": "Ayan",
    "depends_on_past": False,
    "email_on_failure": True,
    "email": ["your@email.com"],
    "retries": 0,
    "retry_delay": timedelta(minutes=5),
    "start_date": datetime(2025, 3, 10),
}

with DAG(
    dag_id="modular_stock_ingestion_dag",
    default_args=default_args,
    # schedule_interval="0 22 * * *",
    schedule="0 22 * * *",  # <-- no schedule_interval anymore

    # timetable=CronDataIntervalTimetable(
    #     cron="0 22 * * *",
    #     timezone="UTC"
    # ),

    catchup=False,
    description="Modular DAG to fetch, transform, and store yfinance S&P 500 stock data",
) as dag:


    get_symbols = PythonOperator(
        task_id="get_symbols",
        python_callable=get_symbols_task,
        # provide_context=True, # Deprecated in Airflow 3.0
    )

    fetch_data = PythonOperator(
        task_id="fetch_data",
        python_callable=fetch_data_task,
        op_args=['1d'],
        # provide_context=True,
    )

    transform_and_store = PythonOperator(
        task_id="transform_and_store",
        python_callable=transform_and_store_task,
        # provide_context=True,
    )

    get_symbols >> fetch_data >> transform_and_store



