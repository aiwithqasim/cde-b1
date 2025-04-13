--                Row Number()
CREATE TABLE t1 (
    id INT IDENTITY(1, 1), 
    a  INT, 
    b  INT, 
	created_at datetime,
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

select * from t1;

with cte as(
select *,
	ROW_NUMBER () OVER (PARTITION BY a, b order by a,b ) as row_num
	from t1)
delete from t1 
where id in ( select id from cte  where row_num>1)


INSERT INTO
    t1(a,b,created_at)
VALUES
    (1,3,getdate())


select *,
	ROW_NUMBER () OVER (PARTITION BY a, b order by created_at desc) as row_num
	from t1;

CREATE TABLE sales.rank_demo (
	v VARCHAR(10)
);
INSERT INTO sales.rank_demo(v)
VALUES('A'),('B'),('B'),('C'),('C'),('D'),('E');


select * from sales.rank_demo;

--                       Rank & Dense Rank
select v,
	rank() over( order by v ) as rank_no,
	dense_rank() over( order by v ) as rank_no_dense
	from sales.rank_demo

-- Lead & Lag

CREATE VIEW sales.vw_netsales_brands
AS
	SELECT 
		c.brand_name, 
		MONTH(o.order_date) month, 
		YEAR(o.order_date) year, 
		CONVERT(DEC(10, 0), SUM((i.list_price * i.quantity) * (1 - i.discount))) AS net_sales
	FROM sales.orders AS o
		INNER JOIN sales.order_items AS i ON i.order_id = o.order_id
		INNER JOIN production.products AS p ON p.product_id = i.product_id
		INNER JOIN production.brands AS c ON c.brand_id = p.brand_id
	GROUP BY c.brand_name, 
			MONTH(o.order_date), 
			YEAR(o.order_date);

select * from sales.vw_netsales_brands;


WITH cte_netsales_2017 AS(
	SELECT 
		month, 
		SUM(net_sales) net_sales
	FROM 
		sales.vw_netsales_brands
	WHERE 
		year = 2017
	GROUP BY 
		month
)
SELECT 
	month,
	net_sales,
	LEAD(net_sales,1) OVER (
		ORDER BY month
	) next_month_sales
FROM 
	cte_netsales_2017;
	
	
	WITH cte_netsales_2017 AS(
	SELECT 
		month, 
		SUM(net_sales) net_sales
	FROM 
		sales.vw_netsales_brands
	WHERE 
		year = 2017
	GROUP BY 
		month
)
SELECT 
	month,
	net_sales,
	LAG(net_sales,1) OVER (
		ORDER BY month
	) next_month_sales
FROM 
	cte_netsales_2017;
