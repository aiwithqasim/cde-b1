-- SQL Server Basics

-- Section 1. Querying data

-- SELECT clause with all columns
SELECT * FROM [sales].[customers];

-- SELECT Clause with specific columns
SELECT customer_id, first_name, last_name FROM [sales].[customers];

-- Section 2. Sorting data

-- ORDER BY (on numbers) with DESC
SELECT customer_id, first_name, last_name 
FROM [sales].[customers]
ORDER BY customer_id DESC;

-- ORDER BY ( on strings) with ASC
SELECT customer_id, first_name, last_name 
FROM [sales].[customers]
ORDER BY first_name ASC;

-- Section 3. Limiting rows

-- OFFSET clause
SELECT customer_id, first_name, last_name 
FROM [sales].[customers]
ORDER BY first_name ASC
OFFSET 10 ROWS;

-- OFSET FETCH clause
SELECT customer_id, first_name, last_name 
FROM [sales].[customers]
ORDER BY first_name ASC
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;

-- TOP Clause
SELECT TOP 10 customer_id, first_name, last_name 
FROM [sales].[customers]
ORDER BY first_name ASC;

-- Section 4. Filtering data

-- DISTINCT clause
SELECT DISTINCT city, customer_id, first_name
FROM [sales].[customers];

-- AND/OR operartor
SELECT city, customer_id, first_name
FROM [sales].[customers]
WHERE (city = 'San Angelo' OR city = 'New York') 
		AND customer_id > 178;

-- IN operartor
SELECT city, customer_id, first_name
FROM [sales].[customers]
WHERE city IN ('San Angelo', 'New York', 'Buffalo') 
		AND customer_id > 178;

-- BETWEEN 

select * from sales.customers
where customer_id between 10 and 20;

-- LIKE (wildcards)

/*  (Multiline comment)
The percent wildcard (%): any string of zero or more characters.
The underscore (_) wildcard: any single character.
The [list of characters] wildcard: any single character within the specified set.
The [character-character]: any single character within the specified range.
The [^]: any character that is not within a list or a range.
*/

SELECT * FROM sales.customers
WHERE first_name LIKE 'A%';

SELECT * FROM sales.customers
WHERE first_name LIKE '%n';

SELECT * FROM sales.customers
WHERE first_name LIKE '%an%';

SELECT * FROM sales.customers
WHERE first_name LIKE '[YZ]%';

SELECT * FROM sales.customers
WHERE first_name LIKE '[A-C]%';

SELECT * FROM sales.customers
WHERE first_name LIKE '[^A-C]%';

-- AS (Alias)

SELECT email AS GMAIL_ID, street AS ADDRESS
FROM sales.customers;

-- Section 5. Joining tables

-------------------------------
-- SECTION 05: JOINING DATA
-------------------------------

CREATE SCHEMA hr;
go

CREATE TABLE hr.candidates(
	id INT IDENTITY(1,1) PRIMARY KEY,
	fullname VARCHAR(100) NOT NULL
);

CREATE TABLE hr.employees(
	id INT IDENTITY(1,1) PRIMARY KEY,
	fullname VARCHAR(100) NOT NULL
);

INSERT INTO hr.candidates(fullname)
VALUES
    ('John Doe'),
    ('Lily Bush'),
    ('Peter Drucker'),
    ('Jane Doe');

INSERT INTO hr.employees(fullname)
VALUES
    ('John Doe'),
    ('Jane Doe'),
    ('Michael Scott'),
    ('Jack Sparrow');

SELECT * FROM hr.employees;
SELECT * FROM hr.candidates;

-- hr.employees ==> LEFT TABLE
-- hr.candidates ==> RIGHT TABLE

-- INNER 
SELECT e.id, c.fullname
FROM hr.employees AS e
INNER JOIN hr.candidates AS c
ON e.fullname = c.fullname;


-- LEFT
SELECT * FROM hr.employees;
SELECT * FROM hr.candidates;

SELECT e.id, c.fullname
FROM hr.employees AS e
LEFT JOIN hr.candidates AS c
ON e.fullname = c.fullname;

-- RIGHT
SELECT * FROM hr.employees;
SELECT * FROM hr.candidates;

SELECT e.id, c.fullname
FROM hr.employees AS e
RIGHT JOIN hr.candidates AS c
ON e.fullname = c.fullname;

-- FULL JOIN
SELECT * FROM hr.employees;
SELECT * FROM hr.candidates;

SELECT e.id, c.fullname
FROM hr.employees AS e
FULL JOIN hr.candidates AS c
ON e.fullname = c.fullname;


-- LEFT-ANTI JOIN
SELECT e.id, e.fullname
FROM hr.employees AS e
LEFT JOIN hr.candidates AS c
ON e.fullname = c.fullname
WHERE c.fullname IS NULL;

-- RIGHT-ANTI
SELECT c.id, c.fullname
FROM hr.employees AS e
RIGHT JOIN hr.candidates AS c
ON e.fullname = c.fullname
WHERE e.id IS NULL;

/*
setA = {1,2,3}
setb = {A,B}
cross = (1,A), (1,B), (2,A).....
*/

-- 5.4 SQL Server Cross Join

CREATE TABLE Meals(MealName VARCHAR(100));
CREATE TABLE Drinks(DrinkName VARCHAR(100));

INSERT INTO Drinks
VALUES('Orange Juice'), ('Tea'), ('Cofee');

INSERT INTO Meals
VALUES('Omlet'), ('Fried Egg'), ('Sausage');

SELECT *
FROM Meals;

SELECT *
FROM Drinks;

SELECT *
FROM Meals
CROSS JOIN Drinks;

-- 5.5 SQL Server Self Join
SELECT * FROM SALES.staffs

SELECT e.first_name as Emp_FName, e.last_name as Emp_LName, 
		m.first_name as Manager_FNAME
FROM sales.staffs e 
JOIN sales.staffs m ON m.staff_id = e.manager_id
where e.active = 1 and e.store_id = 1;


