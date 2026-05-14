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

-- Standardizing the column name for consistency
ALTER TABLE  customer_churn_staging RENAME COLUMN customerID TO customer_id;
ALTER TABLE  customer_churn_staging RENAME COLUMN SeniorCitizen TO senior_citizen;
ALTER TABLE  customer_churn_staging RENAME COLUMN Partner TO partner;
ALTER TABLE  customer_churn_staging RENAME COLUMN Dependents TO dependents;
ALTER TABLE  customer_churn_staging RENAME COLUMN PhoneService TO phone_service;
ALTER TABLE  customer_churn_staging RENAME COLUMN MultipleLines TO multiple_lines;
ALTER TABLE  customer_churn_staging RENAME COLUMN InternetService TO internet_service;
ALTER TABLE  customer_churn_staging RENAME COLUMN OnlineSecurity TO online_security;
ALTER TABLE  customer_churn_staging RENAME COLUMN OnlineBackup TO online_backup;
ALTER TABLE  customer_churn_staging RENAME COLUMN DeviceProtection TO device_protection;
ALTER TABLE  customer_churn_staging RENAME COLUMN TechSupport TO tech_support;
ALTER TABLE  customer_churn_staging RENAME COLUMN StreamingTV TO streaming_tv;
ALTER TABLE  customer_churn_staging RENAME COLUMN StreamingMovies TO streaming_movies;
ALTER TABLE  customer_churn_staging RENAME COLUMN Contract TO contract;
ALTER TABLE  customer_churn_staging RENAME COLUMN PaperlessBilling TO paper_less_billing;
ALTER TABLE  customer_churn_staging RENAME COLUMN PaymentMethod TO payment_method;
ALTER TABLE  customer_churn_staging RENAME COLUMN MonthlyCharges TO monthly_charges;
ALTER TABLE  customer_churn_staging RENAME COLUMN TotalCharges TO total_charges;
ALTER TABLE  customer_churn_staging RENAME COLUMN Churn TO churn;

SELECT *
FROM customer_churn_staging;

-- USE CTE to detect logical duplicates
WITH logical_duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER( 
PARTITION BY gender, senior_citizen, partner, dependents, tenure, phone_service, multiple_lines, internet_service, 
online_security, online_backup, device_protection, tech_support, streaming_tv, streaming_movies, contract, 
paper_less_billing, payment_method, monthly_charges, total_charges, churn) AS row_num
FROM customer_churn_staging
)

SELECT *
FROM logical_duplicate_cte
WHERE row_num > 1;

CREATE TABLE `customer_churn_staging2` (
  `customer_id` text,
  `gender` text,
  `senior_citizen` int DEFAULT NULL,
  `partner` text,
  `dependents` text,
  `tenure` int DEFAULT NULL,
  `phone_service` text,
  `multiple_lines` text,
  `internet_service` text,
  `online_security` text,
  `online_backup` text,
  `device_protection` text,
  `tech_support` text,
  `streaming_tv` text,
  `streaming_movies` text,
  `contract` text,
  `paper_less_billing` text,
  `payment_method` text,
  `monthly_charges` double DEFAULT NULL,
  `total_charges` double DEFAULT NULL,
  `churn` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM customer_churn_staging2;

INSERT INTO customer_churn_staging2
SELECT *
FROM customer_churn_staging;

SELECT *
FROM customer_churn_staging2;