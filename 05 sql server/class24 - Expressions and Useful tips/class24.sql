CREATE SCHEMA test;
GO

CREATE TABLE test.products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2) CHECK(unit_price > 0)
);

INSERT INTO test.products(product_name, unit_price)
VALUES ('Awesome Free Bike', 50);

SELECT * FROM test.products;

DROP TABLE test.products;

CREATE TABLE  test.products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2) CHECK(unit_price > 0),
    discounted_price DEC(10,2) CHECK(discounted_price > 0),
	CHECK (discounted_price < unit_price)
);

INSERT INTO test.products(product_name, unit_price, discounted_price)
VALUES ('Awesome Free Bike', 50, 5);

SELECT * FROM test.products;

SELECT order_status, SUM(order_id) as orders_count
FROM [sales].[orders]
GROUP BY order_status;

SELECT 
	CASE order_status
		WHEN 1 THEN 'Pending'
        WHEN 2 THEN 'Processing'
        WHEN 3 THEN 'Rejected'
        WHEN 4 THEN 'Completed'
	END AS order_status,
	SUM(order_id) as orders_count
FROM [sales].[orders]
GROUP BY order_status;

SELECT SUM(CASE order_status
		WHEN 1 THEN 1 ELSE 0 END) AS 'Pending',
		SUm(CASE order_status
		WHEN 2 THEN 1 ELSE 0 END) AS 'Processing',
		SUM(CASE order_status
		WHEN 3 THEN 1 ELSE 0 END) AS 'Rejected',
		SUM(CASE order_status
		WHEN 4 THEN 1 ELSE 0 END) AS 'Completed',
		COUNT(order_status) AS total_orders
FROM [sales].[orders]

-- SUMMARY
-- METHOD 1- directly on ALL values
-- METHOD 2- Apply the cases on individual values seperately with THEN/ELSE

SELECT
	first_name,
	COALESCE(phone, '1') AS phone
FROM [sales].[customers];


CREATE TABLE salaries (
    staff_id INT PRIMARY KEY,
    hourly_rate decimal,
    weekly_rate decimal,
    monthly_rate decimal,
    CHECK(
        hourly_rate IS NOT NULL OR 
        weekly_rate IS NOT NULL OR 
        monthly_rate IS NOT NULL)
);


INSERT INTO 
    salaries(
        staff_id, 
        hourly_rate, 
        weekly_rate, 
        monthly_rate
    )
VALUES
    (1,20, NULL,NULL),
    (2,30, NULL,NULL),
    (3,NULL, 1000,NULL),
    (4,NULL, NULL,6000),
    (5,NULL, NULL,6500);

SELECT * FROM salaries;

SELECT
    staff_id,
    COALESCE(
        hourly_rate*22*8, 
        weekly_rate*4, 
        monthly_rate
    ) monthly_salary
FROM
    salaries;


SELECT 
    NULLIF(10, 11) result;

SELECT 
    NULLIF('Hello', 'Hi') result;

-- handling duplicates part-1

DROP TABLE IF EXISTS t1;
CREATE TABLE t1 (
    id INT IDENTITY(1, 1), 
    a  INT, 
    b  INT, 
    PRIMARY KEY(id)
);

INSERT INTO
    t1(a,b)
VALUES
    (1,1),
    (1,2),
    (1,3),
    (2,1),
    (1,2),
    (1,3),
    (2,1),
    (2,2);

SELECT * FROM t1;

WITH duplidate_cte AS 
(
	select a,b, count(*) as occurance
	from t1
	group by a,b
	having count(*) > 1
)
SELECT t1.id, t1.a, t1.b, cte.occurance
FROM t1 
INNER JOIN duplidate_cte cte
ON t1.a = cte.a and t1.b = cte.b;

-- METHOD - 2

with cte as
(
	SELECT a, b, ROW_NUMBER() OVER (
				PARTITION BY a,b
				ORDER BY a,b) rownum
	FROM t1
)
delete from cte
where cte.rownum >1;

select * from t1;
