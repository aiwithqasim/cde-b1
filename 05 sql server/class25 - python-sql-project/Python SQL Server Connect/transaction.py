import logging
import pyodbc
from connect import create_connection


def create_order(customer_id: int, book_id: int, quantity: int, price: float, order_date: str) -> bool:
    # Connect to the SQL Server
    conn = create_connection()

    if conn is None:
        return False

    try:
        # Create a cursor
        with conn.cursor() as cursor:
            # Check inventory
            cursor.execute("SELECT Qty FROM Inventories WHERE BookId = ?", (book_id,))
            row = cursor.fetchone()

            if row is None or row[0] < quantity:
                raise Exception("Insufficient inventory")

            # Calculate the total amount
            total_amount = price * quantity

            # Insert into Orders
            cursor.execute("INSERT INTO Orders (OrderDate, CustomerId, TotalAmount) VALUES (?, ?, ?)", 
                           (order_date, customer_id, total_amount))
            order_id = cursor.lastrowid  # Get the last inserted OrderId

            # Insert into OrderDetails
            cursor.execute("INSERT INTO OrderDetails (OrderId, BookId, Quantity, Price) VALUES (?, ?, ?, ?)", 
                           (order_id, book_id, quantity, price))

            # Update Inventories
            cursor.execute("UPDATE Inventories SET Qty = Qty - ? WHERE BookId = ?", (quantity, book_id))

            # Commit the transaction
            conn.commit()        
            return True

    except Exception as e:
        logging.error(f"Error creating order: {e}")
        conn.rollback()

    return False

if __name__ == "__main__":
    customer_id = 1
    book_id = 1
    quantity = 2
    price = 19.99
    order_date = '2023-10-01'

    if create_order(customer_id, book_id, quantity, price, order_date):
        print("Order created successfully.")
    else:
        print("Failed to create order.")



# INSERT INTO Books (Title, Publisher, ISBN, PublishedDate) VALUES
# ('Mastering SQL: A Comprehensive Guide', 'Tech Books Publishing', '978-1234567890', '2022-01-15'),
# ('The Art of Database Design', 'Expert Press', '978-0987654321', '2021-06-10'),
# ('SQL Queries for Mere Mortals', 'Practical SQL Publishing', '978-1122334455', '2023-03-21'),
# ('Advanced SQL Programming Techniques', 'Pro Code Press', '978-6677889900', '2020-09-30'),
# ('Database Systems: Theory and Practice', 'Academic Press', '978-5566778899', '2022-11-05');

# DECLARE @BookID1 INT, @BookID2 INT, @BookID3 INT, @BookID4 INT, @BookID5 INT;

# SELECT @BookID1 = BookID FROM Books WHERE ISBN = '978-1234567890';
# SELECT @BookID2 = BookID FROM Books WHERE ISBN = '978-0987654321';
# SELECT @BookID3 = BookID FROM Books WHERE ISBN = '978-1122334455';
# SELECT @BookID4 = BookID FROM Books WHERE ISBN = '978-6677889900';
# SELECT @BookID5 = BookID FROM Books WHERE ISBN = '978-5566778899';

# -- Insert records into the BookAuthors table
# INSERT INTO BookAuthors (BookID, AuthorID)
# VALUES (@BookID1, 1),
#        (@BookID2, 1),
#        (@BookID3, 1),
#        (@BookID4, 1),
#        (@BookID5, 1);

# INSERT INTO Inventories (BookID, Qty)
# SELECT BookID, ABS(CHECKSUM(NEWID()) % 101) + 100
# FROM Books;
 
