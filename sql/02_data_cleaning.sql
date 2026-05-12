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