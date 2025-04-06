from connect import create_connection
import logging

def update_customer_email(customer_id: int, email: str) -> bool:
    conn = create_connection()
    if conn is None:
        return False

    try:
        with conn.cursor() as cursor:
            cursor.execute(
                "UPDATE sales.customers SET email = ? WHERE customer_id = ?",
                (email, customer_id),
            )
            conn.commit()
            
            logging.info(f'{cursor.rowcount} rows updated successfully.')
            
            return cursor.rowcount == 1
    except Exception as e:
        logging.error(f"Error updating customer email: {e}")
        return False

logging.basicConfig(level=logging.INFO)
customer_id = 1
new_email = 'newemail@example.com'
result = update_customer_email(customer_id, new_email)
if result:
    print("Customer email updated successfully.")
else:
    print("Failed to update customer email.")
