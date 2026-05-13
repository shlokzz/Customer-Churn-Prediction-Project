-- Data Cleaning

SELECT *
FROM customer_churn;

CREATE TABLE customer_churn_staging
LIKE customer_churn;

SELECT *
FROM customer_churn_staging;

INSERT customer_churn_staging
SELECT *
FROM customer_churn;

SELECT * 
FROM customer_churn_staging;

-- Identify the duplicated rows
SELECT *, 
ROW_NUMBER() OVER( 
PARTITION BY customerID) AS row_num
FROM customer_churn_staging;

-- USE CTE to detect duplicate unique rows
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER( 
PARTITION BY customerID) AS row_num
FROM customer_churn_staging
)

SELECT * 
FROM  duplicate_cte
WHERE row_num > 1;

-- Verify that customerID is a unique primary key to identify duplicates
SELECT COUNT(customerID) AS total_rows,
COUNT(DISTINCT customerID) AS unique_rows
FROM customer_churn_staging;