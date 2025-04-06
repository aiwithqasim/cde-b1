from connect import create_connection
from utils import read_csv
import logging


def bulk_copy_customers(filename:str) -> bool:
    customers = read_csv(filename)
    if not customers:
        return False
    
    conn = create_connection()
    if conn is None:
        return False
    
    with conn:
        conn.bulk_copy('Customers',customers)
        conn.commit()

    return True


def bulk_copy_customers_executemany(filename: str) -> bool:
    customers = read_csv(filename)
    if not customers:
        logging.error("No customers to insert.")
        return False

    conn = create_connection()
    if conn is None:
        logging.error("Failed to connect to SQL Server.")
        return False

    try:
        cursor = conn.cursor()
        cursor.executemany(
            "INSERT INTO Authors (FirstName, LastName, BirthDate) VALUES (?, ?, ?)",
            customers
        )
        conn.commit()
        logging.info(f"✅ Inserted {len(customers)} customers successfully.")
        return True
    except Exception as e:
        logging.error(f"❌ Bulk insert failed: {e}")
        return False
    finally:
        conn.close()


# Run the function
if __name__ == "__main__":
    bulk_copy_customers_executemany('authors.csv')

