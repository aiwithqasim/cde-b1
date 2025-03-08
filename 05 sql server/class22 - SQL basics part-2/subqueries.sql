USE BikeStores;

-- SUBQUERY
select (first_name + ' ' + last_name) as Full_Name, city from 
sales.customers

where zip_code in
(
select zip_code  
from sales.customers
where zip_code > 5000
);

SELECT * FROM sales.orders;

select * from sales.orders
where customer_id in (
	select customer_id 
	from sales.customers
	where first_name like ('[A-B]%')
)

-- Find the sales orders of the customers located in New York
select * from sales.orders
where customer_id in (
	select customer_id 
	from sales.customers
	where city like ('New York')
)
order by order_id;

-- NESTED SUBQUERY
-- Get me the product name for the brands Strider and Trek where they have greater
-- sales then there average sales.
SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price > (
        SELECT
            AVG (list_price)
        FROM
            production.products
        WHERE
            brand_id IN (
                SELECT
                    brand_id
                FROM
                    production.brands
                WHERE
                    brand_name = 'Strider'
                OR brand_name = 'Trek'
            )
    )
ORDER BY
    list_price, product_name;

-- SUBQUERY IN COLUMN SECTION
SELECT
    order_id,
    order_date,
    (
        SELECT
            MAX (list_price)
        FROM
            sales.order_items i
        WHERE
            i.order_id = o.order_id
    ) AS max_list_price
FROM
    sales.orders o
order by order_date desc;

-- CORELATED SUBQUERY
SELECT
    product_name,
    list_price,
    category_id
FROM
    production.products p1
WHERE
    list_price IN (
        SELECT
            MAX (p2.list_price)
        FROM
            production.products p2
        WHERE
            p2.category_id = p1.category_id
        GROUP BY
            p2.category_id
    )
ORDER BY
    category_id,
    product_name;

SELECT product_name, (list_price), category_id FROM production.products
where category_id = '5' 
order by list_price desc

-- EXISTS OPERATOR IN SUB QUERY
SELECT
    customer_id,
    first_name,
    last_name,
	phone
FROM
    sales.customers
WHERE
    EXISTS (SELECT NULL)
ORDER BY
    first_name,
    last_name;

-- ANY OPERATOR FOR SUBQUERY
-- IN and = ANY OPERATOR WORKS THE SAME WAY
SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    product_id = ANY (
        SELECT
            product_id
        FROM
            sales.order_items
        WHERE
            quantity >= 2
    )
ORDER BY
    product_name;

-- UNION
-- (columns must be same)
/*
query_1
UNION ALL
query_2
*/

SELECT
    first_name,
    last_name
FROM
    sales.staffs
UNION all
SELECT
    first_name,
    last_name
FROM
    sales.customers;

-- FINDING DUPLICATE
SELECT first_name, last_name, count(*) as duplicate_rows
from 
(SELECT
    first_name,
    last_name
FROM
    sales.staffs
UNION all
SELECT
    first_name,
    last_name
FROM
    sales.customers) as table1
group by first_name, last_name
having count(*)>1;

-- EXCEPT
/*
query_1
EXCEPT
query_2
*/

SELECT
    product_id
FROM
    production.products
EXCEPT
SELECT
    product_id
FROM
    sales.order_items;

-- INTERSECT STATEMENT
/*
query_1
INTERSECT
query_2
*/
SELECT
    city
FROM
    sales.customers
INTERSECT
SELECT
    city
FROM
    sales.stores
ORDER BY
    city;

-- COMMON TABLE EXPRESSIONS (CTEs)
/*
WITH expression_name[(column_name [,...])]
AS
    (CTE_definition)
SQL_statement;
*/

WITH cte_sales_amounts (staff, sales, year) AS (
    SELECT    
        first_name + ' ' + last_name, 
        SUM(quantity * list_price * (1 - discount)),
        YEAR(order_date)
    FROM    
        sales.orders o
    INNER JOIN sales.order_items i ON i.order_id = o.order_id
    INNER JOIN sales.staffs s ON s.staff_id = o.staff_id
    GROUP BY 
        first_name + ' ' + last_name,
        year(order_date)
)

SELECT
    staff, 
    sales
FROM 
    cte_sales_amounts
WHERE
    year = 2018;

--CTE to return the average number of sales orders in 2018 for all sales staffs.
WITH sales_orders_2018
as
(
	SELECT staff_id, count(order_id) as order_count
	FROM sales.orders
	WHERE YEAR(order_date) = 2018
	GROUP BY staff_id
)

SELECT staff_id, AVG(order_count) as Average_order_by_staff
FROM sales_orders_2018
GROUP BY staff_id, order_count

-- MULTIPLE CTEs
WITH cte_category_counts (
    category_id, 
    category_name, 
    product_count
)
AS (
    SELECT 
        c.category_id, 
        c.category_name, 
        COUNT(p.product_id)
    FROM 
        production.products p
        INNER JOIN production.categories c 
            ON c.category_id = p.category_id
    GROUP BY 
        c.category_id, 
        c.category_name
),
cte_category_sales(category_id, sales) AS (
    SELECT    
        p.category_id, 
        SUM(i.quantity * i.list_price * (1 - i.discount))
    FROM    
        sales.order_items i
        INNER JOIN production.products p 
            ON p.product_id = i.product_id
        INNER JOIN sales.orders o 
            ON o.order_id = i.order_id
    WHERE order_status = 4 -- completed
    GROUP BY 
        p.category_id
) 

SELECT 
    c.category_id, 
    c.category_name, 
    c.product_count, 
    s.sales
FROM
    cte_category_counts c
    INNER JOIN cte_category_sales s 
        ON s.category_id = c.category_id
ORDER BY 
    c.category_name;

--PIVOT TABLE
-- FIND THE NUMBER OF PRODUCTS EACH CAGTEGORY CONTAINS 
SELECT * FROM   
(
    SELECT 
        category_name, 
        product_id,
        model_year
    FROM 
        production.products p
        INNER JOIN production.categories c 
            ON c.category_id = p.category_id
) t 
PIVOT(
    COUNT(product_id) 
    FOR category_name IN (
        [Children Bicycles], 
        [Comfort Bicycles], 
        [Cruisers Bicycles], 
        [Cyclocross Bicycles], 
        [Electric Bikes], 
        [Mountain Bikes], 
        [Road Bikes])
) AS pivot_table;




