                SELECT * FROM sysobjects 
                WHERE name='Authors' AND xtype='U';


select * from Authors;
EXEC uspProductList;
drop procedure uspProductList;


CREATE PROCEDURE uspProductList
AS
BEGIN
    SELECT 
        product_name, 
        list_price
    FROM 
        production.products
    ORDER BY 
        product_name;
END;



DECLARE @model_year SMALLINT, 
        @product_name VARCHAR(MAX);
SET @model_year = 2018;

SELECT
    product_name,
    model_year,
    list_price 
FROM 
    production.products
WHERE 
    model_year = @model_year
ORDER BY
    product_name;


DECLARE @product_count INT;
set @product_count = (
select count(*) from production.products );
select @product_count as total_count;
print @product_count;



CREATE  PROC uspGetProductList(
    @model_year SMALLINT
) AS 
BEGIN
    DECLARE @product_list VARCHAR(MAX);

    SET @product_list = '';

    SELECT
        @product_list = @product_list + product_name 
                        + CHAR(10)
    FROM 
        production.products
    WHERE
        model_year = @model_year
    ORDER BY 
        product_name;

    PRINT @product_list;
END;

exec uspGetProductList 2018;


exec sales.daily_sales 2016;
CREATE PROC sales.daily_sales(
    @model_year SMALLINT)
	AS
BEGIN
	SELECT
		year(order_date) AS y,
		month(order_date) AS m,
		day(order_date) AS d,
		p.product_id,
		product_name,
		quantity * i.list_price AS sales
	FROM
		sales.orders AS o
	INNER JOIN sales.order_items AS i
		ON o.order_id = i.order_id
	INNER JOIN production.products AS p
		ON p.product_id = i.product_id
	where year(order_date) = @model_year;
END;

--  sytnax parameter_name data_type OUTPUT
CREATE PROCEDURE uspFindProductByModel (
    @model_year SMALLINT,
    @product_count INT OUTPUT
) AS
BEGIN
    SELECT 
        product_name,
        list_price
    FROM
        production.products
    WHERE
        model_year = @model_year;

    SELECT @product_count = @@ROWCOUNT;
END;



DECLARE @count INT;

EXEC uspFindProductByModel
    @model_year = 2018,
    @product_count = @count OUTPUT;

SELECT @count AS 'Number of products found';



IF boolean_expression   
BEGIN
    { statement_block }
END




DECLARE @counter INT = 1;

WHILE @counter <= 10
BEGIN
    PRINT @counter;
	IF @counter = 4
		BREAK
    SET @counter = @counter + 1;
END



DECLARE @counter INT = 1;

WHILE @counter <= 10
BEGIN
    PRINT @counter;
	IF @counter = 4
		CONTINUE
    SET @counter = @counter + 1;
END