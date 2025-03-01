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






