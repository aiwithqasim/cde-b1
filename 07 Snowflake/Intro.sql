// OLTP (sql-server) vs OLAP (snowflake)

-- t1
-- intraday
-- realtime

-- snowlfake
-- snowflake-sample data

SELECT * FROM snowflake_sample_data.tpch_sf1.customer; -- fyully qualified naming

// CONTEXT SETTINGS

-- CTRL+/ ( COMMENT UNCOMMENT)

-- optional
-----------
-- 1.DATABASE
-- 2.SCHEMA

USE DATABASE snowflake_sample_data;
USE SCHEMA tpch_sf1;

-- required
-----------
-- 3.ROLE
-- 4.WAREHOUSE

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE RETAIL_WH_XS;

// CREATE WAREHOUSE
-- best practice: <domain-type-size>

-- METHOD-1 (FROM UI)
-- METHOD-2 (FROM CODE)

CREATE OR REPLACE WAREHOUSE PRACTICE_WH_XS
WAREHOUSE_SIZE = XSMALL -- vertical scaling
AUTO_RESUME=TRUE
AUTO_SUSPEND= 120
MIN_CLUSTER_COUNT=1
MAX_CLUSTER_COUNT=2
SCALING_POLICY='STANDARD'
INITIALLY_SUSPENDED=TRUE
COMMENT='This is a practice warehosue from code';

ALTER WAREHOUSE PRACTICE_WH_XS RESUME;
ALTER WAREHOUSE PRACTICE_WH_XS SUSPEND;
ALTER WAREHOUSE PRACTICE_WH_XS SET WAREHOUSE_SIZE = SMALL; -- also without quote it will work
ALTER WAREHOUSE PRACTICE_WH_XS SET WAREHOUSE_SIZE = 'XSMALL';
ALTER WAREHOUSE PRACTICE_WH_XS SET AUTO_SUSPEND=60;


// MULTI-CLUSRTERING (horizental scalling)

-- - MIN_CLUSTER_COUNT
-- - MAX_CLUSTER_COUNT

-- TWO TYPES of scaling policies at i:e., peak hours 
    -- 1. STANDARD (defualt)
        -- Prevent / minimize queuing of workloads
        -- After 2-3 Consective runs it reduce automatically
        -- Focus on PERFORMANCE
    -- 2. ECONOMY 
        -- Conserve credists by running fully loaded clusters ( Enough load to keep the cluster busy for 6 minutes )
        -- 5-6 consective runs
        -- Focus on PIRICING/CREDITS

// PRICING ON SIZES


-- XSMALL ==> 2^0 = 1 credeti/hour (eg: cloud provider, region)
-- What will be the pricing of using XSmall wh continuosuly 8 houes in AWS us-east region?
-- 24$

-- What will be the pricing of using 4XL wh continuosuly 3 houes in AWS Mumbai region?
-- (128credits/hours) * (3hr) * (3.30 in AWS  mumbai)
-- 128 * 3 * 3.30 ==> 167.2$

-- COST MANAGEMENT
-- docs: https://www.snowflake.com/en/pricing-options/

----------------------------------------------------------------------------

CREATE DATABASE PRACTICE_DB;
CREATE SCHEMA PRACTICE_DB.PRACTICE_SCEHMA;

DROP SCHEMA PRACTICE_DB.PUBLIC;

-- https://docs.snowflake.com/en/data-types
CREATE OR REPLACE TABLE PRACTICE_TABLE(
    FIST_COL VARCHAR,
    SECOND_COL VARCHAR
);

-------------------------------------------------------------------------------

-- Altering db
ALTER DATABASE PRACTICE_DB RENAME TO "OUR_FIRST_DB";
USE DATABASE OUR_FIRST_DB;
CREATE SCHEMA OUR_FIRST_DB.PUBLIC;

-- Creating the table / Meta data
CREATE TABLE "OUR_FIRST_DB"."PUBLIC"."LOAN_PAYMENT" (
  "Loan_ID" STRING,
  "loan_status" STRING,
  "Principal" STRING,
  "terms" STRING,
  "effective_date" STRING,
  "due_date" STRING,
  "paid_off_time" STRING,
  "past_due_days" STRING,
  "age" STRING,
  "education" STRING,
  "Gender" STRING
);




