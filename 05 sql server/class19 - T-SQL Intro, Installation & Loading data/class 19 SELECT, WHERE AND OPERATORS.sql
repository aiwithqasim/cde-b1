-- SELECT

SELECT * FROM [sales].[customers];
SELECT first_name, last_name, email FROM [sales].[customers];

SELECT first_name, last_name, email 
FROM [sales].[customers]
WHERE first_name = 'Ronna';

SELECT first_name, last_name, email 
FROM [sales].[customers]
WHERE first_name = 'Ronna' OR first_name='Zelma';

SELECT customer_id, first_name, last_name, email 
FROM [sales].[customers]
WHERE first_name IN ('Ronna', 'Zelma', 'Tu');

SELECT *
FROM [sales].[customers]
WHERE customer_id >= 40 AND first_name IN ('Ronna', 'Zelma', 'Tu');

SELECT *
FROM [sales].[customers]
WHERE customer_id < 40 AND first_name IN ('Ronna', 'Zelma', 'Tu');