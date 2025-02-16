-- Section 6. Grouping data

-- GROUP BY
-- without aggregated function all columns should be in GROUBY
-- if have have aggregated function, column should not be in GROUBBY

SELECT  
	customer_id,
	SUM(customer_id) AS order_placed
FROM [sales].[orders]
GROUP BY customer_id
ORDER BY customer_id;

SELECT
    customer_id,
    YEAR (order_date) order_year,
	COUNT(order_id) AS order_placed
FROM sales.orders
--WHERE customer_id IN (1, 2)
GROUP BY customer_id, YEAR (order_date)
ORDER BY customer_id, order_year;

-- EXECUTION PLAN 
-- FROM >> WHERE >> GROUPBY >> HAVING >> SELECT >> ORDERBY >> LIMIT

SELECT
	state,
	city,
	COUNT(customer_id) AS customer_count
FROM sales.customers
GROUP BY city, state
ORDER BY city, state;

SELECT 
	brand_name,
	product_name,
	model_year,
	MAX(list_price) AS max_price,
	MIN(list_price) AS min_price,
	AVG(list_price) AS avg_price
FROM [production].[products] AS p
INNER JOIN [production].[brands] AS b
ON p.brand_id = b.brand_id
GROUP BY 
	brand_name,
	product_name,
	model_year;


SELECT 
	brand_name,
	MAX(list_price) AS max_price,
	MIN(list_price) AS min_price,
	AVG(list_price) AS avg_price
FROM [production].[products] AS p
INNER JOIN [production].[brands] AS b
ON p.brand_id = b.brand_id
WHERE model_year = 2018
GROUP BY 
	brand_name;

SELECT
	order_id,
	SUM(list_price * quantity * (1-discount)) AS net_value
FROM [sales].[order_items]
GROUP BY order_id;

-- HAVING
SELECT
    customer_id,
    YEAR (order_date) order_year,
	COUNT(order_id) AS order_placed
FROM sales.orders
--WHERE customer_id IN (1, 2)
GROUP BY customer_id, YEAR (order_date)
HAVING COUNT(order_id) >= 2
ORDER BY customer_id, order_year;

SELECT
	order_id,
	SUM(list_price * quantity * (1-discount)) AS net_value
FROM [sales].[order_items]
GROUP BY order_id
HAVING SUM(list_price * quantity * (1-discount)) > 2000
ORDER BY order_id;

SELECT 
	brand_name,
	MAX(list_price) AS max_price,
	MIN(list_price) AS min_price,
	AVG(list_price) AS avg_price
FROM [production].[products] AS p
INNER JOIN [production].[brands] AS b
ON p.brand_id = b.brand_id
WHERE model_year = 2018
GROUP BY brand_name
HAVING MAX (list_price) > 4000 OR MIN (list_price) < 500;

-- TABLE CREATION sales.sales_summary
SELECT
    b.brand_name AS brand,
    c.category_name AS category,
    p.model_year,
    round(
        SUM (
            quantity * i.list_price * (1 - discount)
        ),
        0
    ) sales INTO sales.sales_summary
FROM
    sales.order_items i
INNER JOIN production.products p ON p.product_id = i.product_id
INNER JOIN production.brands b ON b.brand_id = p.brand_id
INNER JOIN production.categories c ON c.category_id = p.category_id
GROUP BY
    b.brand_name,
    c.category_name,
    p.model_year
ORDER BY
    b.brand_name,
    c.category_name,
    p.model_year;

-- GROUPSETS
--(brand, category)
--(brand)
--(category)
--()

SELECT 
	brand,
	--category,
	SUM(sales) AS sales
FROM [sales].[sales_summary]
GROUP BY brand --, category;

SELECT 
	category,
	SUM(sales) AS sales
FROM [sales].[sales_summary]
GROUP BY category;

SELECT 
	SUM(sales) AS sales
FROM [sales].[sales_summary]

-- with UNION
SELECT
    brand,
    category,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
    brand,
    category
UNION ALL
SELECT
    brand,
    NULL,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
    brand
UNION ALL
SELECT
    NULL,
    category,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
    category
UNION ALL
SELECT
    NULL,
    NULL,
    SUM (sales)
FROM
    sales.sales_summary
ORDER BY brand, category;


SELECT
    brand,
    category,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY 
GROUPING SETS (
		(brand, category),
		(brand),
		(category),
		()
);

SELECT
    brand,
    category,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY 
	CUBE(brand, category);

SELECT
    brand,
    category,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
	brand,
	CUBE(category);

-- ROOLUPS (c1, c2)
-- (brand, category)
-- (brand)
-- ()

SELECT
    brand,
    category,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
	ROLLUP (brand, category);

