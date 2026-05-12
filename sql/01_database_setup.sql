CREATE DATABASE IF NOT EXISTS telco_customer_churn;
USE telco_customer_churn;

CREATE TABLE `customer_churn` (
  `customerID` text,
  `gender` text,
  `SeniorCitizen` int DEFAULT NULL,
  `Partner` text,
  `Dependents` text,
  `tenure` int DEFAULT NULL,
  `PhoneService` text,
  `MultipleLines` text,
  `InternetService` text,
  `OnlineSecurity` text,
  `OnlineBackup` text,
  `DeviceProtection` text,
  `TechSupport` text,
  `StreamingTV` text,
  `StreamingMovies` text,
  `Contract` text,
  `PaperlessBilling` text,
  `PaymentMethod` text,
  `MonthlyCharges` double DEFAULT NULL,
  `TotalCharges` double DEFAULT NULL,
  `Churn` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- I used MySQL GUI for initial import due to local permission constraints; command below provided for bulk loading reference

-- Replace the path below  with your local absolute path to the CSV file
/*
LOAD DATA INFILE 'YOUR_ABSOLUTE_PATH_HERE/telco-customer-churn.csv'
INTO TABLE layoffs
FIELDS TERMINATED by ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; 
*/