-- Exploratory Data Analysis

SELECT *
FROM customer_churn_staging2;

-- Check the minimum, maximum and average value of numeric features
SELECT 'tenure' as metric, MIN(tenure) as min_value, MAX(tenure) as max_value, ROUND(AVG(tenure),2) as average
FROM customer_churn_staging2 
UNION ALL
SELECT 'total_charges', MIN(total_charges), MAX(total_charges), ROUND(AVG(total_charges),2)
FROM customer_churn_staging2
UNION ALL
SELECT 'monthly_charges', MIN(monthly_charges), MAX(monthly_charges), ROUND(AVG(monthly_charges),2)
FROM customer_churn_staging2;
