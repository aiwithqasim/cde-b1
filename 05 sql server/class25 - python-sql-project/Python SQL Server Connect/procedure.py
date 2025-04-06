from connect import create_connection

def get_products_list() -> list[dict] | None:
    conn = create_connection()
    if conn is None:
        return None
    
    try:
        with conn.cursor() as cursor:
            cursor.execute('EXEC uspProductList')  # Using EXEC to call the stored procedure
            rows = cursor.fetchall()
            # Convert rows to list of dictionaries
            columns = [column[0] for column in cursor.description]
            return [dict(zip(columns, row)) for row in rows]
    except Exception as e:
        print(f"Error: {e}")
        return None

if __name__ == "__main__":
    result = get_products_list()
    if result:
        for row in result:
            print(row)
    else:
        print("No data found or connection failed.")
