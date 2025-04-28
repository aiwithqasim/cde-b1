import pandas as pd
import yfinance as yf
from datetime import datetime,timedelta
import pyodbc
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.timetables.interval import CronDataIntervalTimetable
import time 
def create_connection():
    # conn_str = (
    #     r"DRIVER={SQL Server};"
    #     r"SERVER=LAPTOP-NEEIVGK7\MSSQLSERVER1;"
    #     r"DATABASE=BikeStores;"
    #     r"Trusted_Connection=yes;"
    # )

    conn_str = (
        r"DRIVER={ODBC Driver 18 for SQL Server};"
        r"SERVER=......\MSSQLSERVER1;"
        r"DATABASE=BikeStores;"
        r"UID=test;"
        r"PWD=Test123*;"
        r"TrustServerCertificate=yes;"
        r"Timeout=30;"

    )
    try:
        conn = pyodbc.connect(conn_str)
        print("✅ Connected to SQL Server successfully!")
        return conn
    except Exception as e:
        print(f"❌ Error connecting to SQL Server: {e}")
        return None

def create_table_if_not_exists(table_name):
    conn = create_connection()
    if not conn:
        return

    cursor = conn.cursor()
    create_table_query = f"""
    IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='{table_name}' and xtype='U')
    CREATE TABLE {table_name} (
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
    try:
        cursor.execute(create_table_query)
        conn.commit()
        print("✅ Table ensured: stock_prices")
    except Exception as e:
        print(f"❌ Error creating table: {e}")
    finally:
        cursor.close()
        conn.close()

def insert_data_to_db(table_name, values):
    conn = create_connection()
    if not conn:
        return

    cursor = conn.cursor()
    insert_query = f"""
    INSERT INTO {table_name} (
        trade_date, close_price, high_price, low_price, open_price,
        volume, symbol, close_change, close_pct_change
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"""

    try:
        cursor.executemany(insert_query, values)
        conn.commit()
        print(f"✅ Inserted {len(values)} rows into {table_name}")
    except Exception as e:
        print(f"❌ Error inserting data: {e}")
    finally:
        cursor.close()
        conn.close()

# Constants
SP500_URL = 'https://en.wikipedia.org/wiki/List_of_S%26P_500_companies'


def get_sp500_tickers():
    tables = pd.read_html(SP500_URL)
    sp500_df = tables[0]
    return sp500_df['Symbol'].tolist()

def fetch_yfinance_data(symbols, start_date, end_date, interval, max_retries=3):
    results = {}
    for symbol in symbols:
        retries = 0
        while retries < max_retries:
            try:
                data = yf.download(
                    tickers=symbol,
                    start=start_date,
                    end=end_date,
                    interval=interval,
                    ignore_tz=True,
                    progress=False
                )
                if not data.empty:
                    results[symbol] = data
                break
            except Exception as e:
                retries += 1
                print(f"Error fetching {symbol} (retry {retries}/{max_retries}): {e}")
                time.sleep(5)
        else:
            print(f"Failed to fetch {symbol} after {max_retries} retries.")
    return results

def transform_data(data, symbol):
    data.columns = [col[0] for col in data.columns]
    data = data.reset_index()

    data = data[data["Close"] != 0]
    data["symbol"] = symbol
    data['close_change'] = data['Close'].diff().fillna(0)
    data['close_pct_change'] = data['Close'].pct_change().fillna(0) * 100
    return data[['Date', 'Close', 'High', 'Low', 'Open', 'Volume', 'symbol', 'close_change', 'close_pct_change']]

def ingest_yfinance_data(symbol_data, final_table, interval):
    values = []
    for symbol in symbol_data:
        try:
            start_date = (datetime.now() - timedelta(days=7)).strftime('%Y-%m-%d')
            end_date = datetime.now().strftime('%Y-%m-%d')
            data_dict = fetch_yfinance_data([symbol], start_date, end_date, interval)
            if symbol in data_dict:
                data = transform_data(data_dict[symbol], symbol)

                if not data.empty:
                    values.extend([tuple(x) for x in data.to_numpy()])
        except Exception as e:
            print(f"Error processing {symbol}: {str(e)}")

    if values:
        insert_data_to_db(final_table, values)


def main(interval,final_table):
    try:
        start = time.time()
        create_table_if_not_exists(final_table)
        # final_table = "stock_prices"

        symbol_data = get_sp500_tickers()
        ingest_yfinance_data(symbol_data[:5], final_table, interval)

        print(f"Processed {len(symbol_data[:5])} symbols in {time.time() - start:.2f} seconds")
    except Exception as e:
        print(f"Main function error: {str(e)}")


default_args = {
    'owner':"Ayan",
    "retries": 0,
    "retry_delay":timedelta(minutes=5),
}

with DAG(
    dag_id = 'daily_stock_prices',
    default_args = default_args,
    description = "Saving OHLCV data daily",
    # schedule_interval= "0 22 * * *", # for airflow 2.0
    schedule="0 22 * * *",  # <-- no schedule_interval anymore

    # timetable=CronDataIntervalTimetable(
    #     cron="0 22 * * *",
    #     timezone="UTC"
    # ),

    start_date=datetime(2025, 4, 26),
    catchup=False,
    tags=['stock_daily'],
) as dag:

    data_task = PythonOperator(
        task_id = "task1",
        python_callable=main,
        op_args=['1d','stock_prices'],
    )

    data_task