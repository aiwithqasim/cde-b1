import logging
from connect import create_connection


def create_authors_table():
    conn = create_connection()
    if conn is None:
        logging.error("Failed to connect to SQL Server.")
        return

    try:
        cursor = conn.cursor()
        cursor.execute("""
            IF NOT EXISTS (
                SELECT * FROM sysobjects 
                WHERE name='Authors' AND xtype='U'
            )
            CREATE TABLE Authors (
                AuthorID INT IDENTITY(1,1) PRIMARY KEY,
                FirstName NVARCHAR(100),
                LastName NVARCHAR(100),
                BirthDate DATE
            );
        """)
        conn.commit()
        logging.info("✅ 'Authors' table created successfully (if it didn't already exist).")
    except Exception as e:
        logging.error(f"❌ Error creating 'Authors' table: {e}")
    finally:
        conn.close()


def insert_author(first_name: str, last_name: str, birth_date: str) -> int | None:
    conn = create_connection()
    if conn is None:
        logging.error("Failed to connect to SQL Server.")
        return None

    try:
        cursor = conn.cursor()
        cursor.execute(
            "INSERT INTO Authors (FirstName, LastName, BirthDate) VALUES (?, ?, ?)",
            (first_name, last_name, birth_date),
        )
        # Fetch the last inserted ID using SCOPE_IDENTITY()
        cursor.execute("SELECT SCOPE_IDENTITY();")
        author_id = cursor.fetchone()[0]

        conn.commit()
        logging.info(f"✅ Author: {first_name} {last_name} inserted successfully. ID: {author_id}")
        return author_id
    except Exception as e:
        logging.error(f"❌ Failed to insert author: {e}")
        return None
    finally:
        conn.close()


# Run everything
if __name__ == "__main__":
    create_authors_table()
    insert_author("Ayan", "Hussain", "2025-01-01")
    insert_author("Uzair", "Khan", "1950-02-02")
