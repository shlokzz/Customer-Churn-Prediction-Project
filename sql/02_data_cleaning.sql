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
  `total_charges` text,
  `churn` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM customer_churn_staging2;

-- Clear the staging table to ensure data is not duplicated when re-runs
TRUNCATE TABLE customer_churn_staging2;

-- Inserting the values in the staging table
INSERT INTO customer_churn_staging2
SELECT *
FROM customer_churn_staging;

SELECT COUNT(*)
FROM customer_churn_staging2;

SELECT *
FROM customer_churn_staging2;

-- Standardardizing Data

SELECT DISTINCT customer_id
FROM customer_churn_staging2;

UPDATE customer_churn_staging2
SET customer_id = TRIM(customer_id);

SELECT DISTINCT gender
FROM customer_churn_staging2;

SELECT DISTINCT senior_citizen
FROM customer_churn_staging2;

SELECT DISTINCT partner
FROM customer_churn_staging2;

SELECT DISTINCT dependents
FROM customer_churn_staging2;

SELECT DISTINCT tenure
FROM customer_churn_staging2
ORDER BY 1;

SELECT DISTINCT phone_service
FROM customer_churn_staging2;

SELECT DISTINCT multiple_lines
FROM customer_churn_staging2;

SELECT DISTINCT internet_service
FROM customer_churn_staging2;

SELECT DISTINCT online_security
FROM customer_churn_staging2;

SELECT DISTINCT online_backup
FROM customer_churn_staging2;

SELECT DISTINCT device_protection
FROM customer_churn_staging2;

SELECT DISTINCT tech_support
FROM customer_churn_staging2;

SELECT DISTINCT streaming_tv
FROM customer_churn_staging2;

SELECT DISTINCT streaming_movies
FROM customer_churn_staging2;

SELECT DISTINCT contract
FROM customer_churn_staging2;

SELECT DISTINCT paper_less_billing
FROM customer_churn_staging2;

SELECT DISTINCT payment_method
FROM customer_churn_staging2;

SELECT DISTINCT monthly_charges
FROM customer_churn_staging2
ORDER BY 1;

SELECT DISTINCT total_charges
FROM customer_churn_staging2
ORDER BY 1;

SELECT total_charges, COUNT(*)
FROM customer_churn_staging2 
WHERE total_charges IS NULL 
OR total_charges = " "
GROUP BY total_charges;

SELECT *
FROM customer_churn_staging2 
WHERE total_charges IS NULL 
OR total_charges = " ";

SELECT total_charges, tenure
FROM customer_churn_staging2 
WHERE total_charges IS NULL 
OR total_charges = " ";

SELECT tenure, total_charges 
FROM customer_churn_staging2
WHERE tenure = 0;

UPDATE customer_churn_staging2
SET total_charges = 0
WHERE total_charges = ' ';

SELECT DISTINCT churn
FROM customer_churn_staging2;

SELECT *
FROM customer_churn_staging2;

-- Check if the columns have any NULL or Empty Values
SELECT 
	SUM(CASE WHEN customer_id IS NULL OR customer_id = " " THEN 1 ELSE 0 END) AS id_nulls,
	SUM(CASE WHEN gender IS NULL OR gender = " " THEN 1 ELSE 0 END) AS gender_nulls,
	SUM(CASE WHEN senior_citizen IS NULL THEN 1 ELSE 0 END) AS citizen_nulls,
	SUM(CASE WHEN partner IS NULL OR partner = " " THEN 1 ELSE 0 END) AS partner_nulls,
	SUM(CASE WHEN dependents IS NULL OR dependents = " " THEN 1 ELSE 0 END) AS dependents_nulls,
	SUM(CASE WHEN tenure IS NULL THEN 1 ELSE 0 END) AS tenure_nulls,
	SUM(CASE WHEN phone_service IS NULL OR phone_service = " " THEN 1 ELSE 0 END) AS phone_service_nulls,
	SUM(CASE WHEN multiple_lines IS NULL OR multiple_lines = " " THEN 1 ELSE 0 END) AS lines_nulls,
	SUM(CASE WHEN internet_service IS NULL OR internet_service = " " THEN 1 ELSE 0 END) AS internet_service_nulls,
	SUM(CASE WHEN online_security IS NULL OR online_security = " " THEN 1 ELSE 0 END) AS online_security_nulls,
	SUM(CASE WHEN online_backup IS NULL OR online_backup = " " THEN 1 ELSE 0 END) AS online_backup_nulls,
	SUM(CASE WHEN device_protection IS NULL OR device_protection = " " THEN 1 ELSE 0 END) AS device_protection_nulls,
	SUM(CASE WHEN tech_support IS NULL OR tech_support = " " THEN 1 ELSE 0 END) AS tech_support_nulls,
	SUM(CASE WHEN streaming_tv IS NULL OR streaming_tv = " " THEN 1 ELSE 0 END) AS streaming_tv_nulls,
	SUM(CASE WHEN streaming_movies IS NULL OR streaming_movies = " " THEN 1 ELSE 0 END) AS streaming_movies_nulls,
	SUM(CASE WHEN contract IS NULL OR contract = " " THEN 1 ELSE 0 END) AS contract_nulls,
	SUM(CASE WHEN paper_less_billing IS NULL OR paper_less_billing = " " THEN 1 ELSE 0 END) AS paper_less_biling_nulls,
	SUM(CASE WHEN payment_method IS NULL OR payment_method = " " THEN 1 ELSE 0 END) AS payment_method_nulls,
	SUM(CASE WHEN monthly_charges IS NULL THEN 1 ELSE 0 END) AS mothly_charges_nulls,
	SUM(CASE WHEN total_charges IS NULL THEN 1 ELSE 0 END) AS total_charges_nulls,
	SUM(CASE WHEN churn IS NULL OR churn = " " THEN 1 ELSE 0 END) AS churn_nulls
FROM customer_churn_staging2;

SELECT COUNT(*)
FROM customer_churn_staging2;
