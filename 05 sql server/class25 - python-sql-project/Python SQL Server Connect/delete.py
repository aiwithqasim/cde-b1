from connect import create_connection

def delete_author(id: int) -> int:
    # Connect to the SQL Server
    conn = create_connection()
    if conn is None:
        return 0
    
    # Delete the author    
    with conn.cursor() as cursor:
        cursor.execute("DELETE FROM Authors WHERE AuthorID = ?", (id,))
        conn.commit()
        return cursor.rowcount
    

if __name__ == "__main__":
    # Example usage
    author_id = 1  
    deleted_count = delete_author(author_id)
    if deleted_count > 0:
        print(f"✅ Deleted {deleted_count} author(s) with ID {author_id}.")
    else:
        print(f"❌ No author found with ID {author_id}.")
