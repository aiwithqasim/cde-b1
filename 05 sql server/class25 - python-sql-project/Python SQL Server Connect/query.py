from connect import create_connection


def find_customer_by_id(customer_id: int) -> dict | None:
    conn = create_connection()
    if conn is None:
        return None

    sql = """SELECT 
                customer_id, first_name, last_name, email, street, city, state, zip_code
             FROM 
                sales.customers 
             WHERE customer_id = ?"""
    
    with conn.cursor() as cursor:
        cursor.execute(sql, (customer_id,))
        row = cursor.fetchone()
        if row:
            columns = [column[0] for column in cursor.description]
            return dict(zip(columns, row))
        return None


def find_customers(term: str) -> list[dict] | None:
    conn = create_connection()
    if conn is None:
        return None

    sql = """SELECT * FROM sales.customers 
             WHERE first_name LIKE ? ORDER BY first_name"""
    
    name = f'%{term}%'
    
    with conn.cursor() as cursor:
        cursor.execute(sql, (name,))
        rows = cursor.fetchall()
        columns = [column[0] for column in cursor.description]
        return [dict(zip(columns, row)) for row in rows]


def get_customers(limit: int, offset: int = 0) -> list[dict] | None:
    conn = create_connection()
    if conn is None:
        return None

    sql = """SELECT * FROM sales.customers ORDER BY customer_id 
            OFFSET ? ROWS FETCH FIRST ? ROWS ONLY"""
    
    with conn.cursor() as cursor:
        cursor.execute(sql, (offset, limit))
        rows = cursor.fetchall()
        columns = [column[0] for column in cursor.description]
        return [dict(zip(columns, row)) for row in rows]


if __name__ == '__main__':
    print(find_customer_by_id(1))
    print(find_customers('Debra'))
    print(get_customers(5, 0))
    print(get_customers(5, 5))
