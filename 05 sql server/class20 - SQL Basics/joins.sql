CREATE TABLE LEFTTABLE (
	DATE DATE,
	COUNTRY_ID INT,
	UNITS INT
);

CREATE TABLE RIGHTTABLE (
	ID INT,
	COUNTRY VARCHAR(100)
);

INSERT INTO LEFTTABLE (DATE,COUNTRY_ID,UNITS) VALUES
('2020-01-01',1,40),
('2020-01-02',1,25),
('2020-01-03',3,30),
('2020-01-04',2,35);


INSERT INTO RIGHTTABLE (ID,COUNTRY) VALUES
(3,'PANAMA'),
(4,'SPAIN');


SELECT * FROM LEFTTABLE;
SELECT * FROM RIGHTTABLE;

SELECT L.DATE  DATE, L.COUNTRY_ID,UNITS, R.COUNTRY AS COUNTRY_NAME
FROM LEFTTABLE L 
INNER JOIN RIGHTTABLE R
ON L.COUNTRY_ID = R.ID;

SELECT L.DATE  DATE, L.COUNTRY_ID,UNITS, R.COUNTRY AS COUNTRY_NAME
FROM LEFTTABLE L 
LEFT JOIN RIGHTTABLE R
ON L.COUNTRY_ID = R.ID;

SELECT L.DATE  DATE, L.COUNTRY_ID,UNITS, R.COUNTRY AS COUNTRY_NAME
FROM LEFTTABLE L 
RIGHT JOIN RIGHTTABLE R
ON L.COUNTRY_ID = R.ID;

SELECT L.DATE  DATE, L.COUNTRY_ID,UNITS, R.COUNTRY AS COUNTRY_NAME
FROM LEFTTABLE L 
FULL JOIN RIGHTTABLE R
ON L.COUNTRY_ID = R.ID;