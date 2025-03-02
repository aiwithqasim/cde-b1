-- Insert Syntax 

-- Insert INTO table_name (column_list)
-- values (value_list)


select count(*) from production.brands;
select * from production.brands;
SET IDENTITY_INSERT production.brands OFF;  

INSERT INTO production.brands(brand_name) VALUES('SMITT')
SET IDENTITY_INSERT production.brands ON;  

INSERT INTO production.brands(brand_id,brand_name) VALUES(100,'Electra');


INSERT INTO production.brands(brand_name)
OUTPUT inserted.brand_id, inserted.brand_name
VALUES('HP');




CREATE TABLE production.brands_demo (
	brand_id INT IDENTITY (1, 1) PRIMARY KEY,
	brand_name VARCHAR (255) NOT NULL
);
-- drop table production.brands_demo

select * from production.brands;

SET IDENTITY_INSERT production.brands_demo ON;  

insert into production.brands_demo(brand_id,brand_name)
select * from production.brands;


-- Update 
Update production.brands
set brand_name = 'TSLA'
where brand_id = 1;



update production.products_demo
set 
	products_demo.product_name  = brands.brand_name
from 
	production.products_demo 
inner join 
	production.brands on brands.brand_id = products_demo.brand_id



select * from production.products_demo;
delete
from production.products_demo
-- where model_year = '2017';




CREATE TABLE sales.category (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL,
    amount DECIMAL(10 , 2 )
);

INSERT INTO sales.category(category_id, category_name, amount)
VALUES(1,'Children Bicycles',15000),
    (2,'Comfort Bicycles',25000),
    (3,'Cruisers Bicycles',13000),
    (4,'Cyclocross Bicycles',10000);


CREATE TABLE sales.category_staging (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL,
    amount DECIMAL(10 , 2 )
);


INSERT INTO sales.category_staging(category_id, category_name, amount)
VALUES(1,'Children Bicycles',15000),
    (3,'Cruisers Bicycles',13000),
    (4,'Cyclocross Bicycles',20000),
    (5,'Electric Bikes',10000),
    (6,'Mountain Bikes',10000);

MERGE sales.category t 
    USING sales.category_staging s
ON (s.category_id = t.category_id)
WHEN MATCHED
    THEN UPDATE SET 
        t.category_name = s.category_name,
        t.amount = s.amount
WHEN NOT MATCHED BY TARGET 
    THEN INSERT (category_id, category_name, amount)
         VALUES (s.category_id, s.category_name, s.amount)
WHEN NOT MATCHED BY SOURCE 
    THEN DELETE;


select * from sales.category