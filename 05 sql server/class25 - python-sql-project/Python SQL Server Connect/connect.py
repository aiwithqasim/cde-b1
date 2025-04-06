import os
import logging
import pyodbc
from dotenv import load_dotenv
# pip install pyodbc load_dotenv
def create_connection():

    # Build connection string using Windows Authentication
    # conn_str = (
    #     r"DRIVER={SQL Server};"
    #     r"SERVER=SMITPAPOSH0030;"  
    #     r"DATABASE=BikeStores;"  
    #     r"Trusted_Connection=yes;" 
    # )

    conn_str = (
        r"DRIVER={SQL Server};"
        r"SERVER=SMITPAPOSH0030;"  
        r"DATABASE=BikeStores;"
        r"UID=sa;"  
        r"PWD=class_cde;"    
    )

    try:
        conn = pyodbc.connect(conn_str)
        print("✅ Connected to SQL Server successfully!")

        return conn
    except pyodbc.Error as e:   
        conn.close()
    except Exception as e:
        logging.error(f"❌ Error connecting to SQL Server: {e}")

# Run the function
if __name__ == "__main__":
    create_connection()
