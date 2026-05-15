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

-- Calculate total and average monthly charges across churn segments
SELECT churn, COUNT(*) AS total_customers, 
ROUND(SUM(monthly_charges),2) AS total_monthly_revenue,
ROUND(AVG(monthly_charges),2) AS avg_monthly_revenue
FROM customer_churn_staging2
GROUP BY churn;

-- Calculate churn rate percentage
SELECT churn, COUNT(*) AS total_customers, 
ROUND(COUNT(*) * 100.0 /(SELECT COUNT(*) FROM customer_churn_staging2), 2) AS percentage
FROM customer_churn_staging2
GROUP BY churn;

-- Calculate churn rates acorss gender demographics 
SELECT churn,gender, COUNT(*) AS total_customers,
ROUND(COUNT(*) * 100.0 /(SELECT COUNT(*) FROM customer_churn_staging2), 2) AS percentage
FROM customer_churn_staging2
GROUP BY churn,gender;

-- Calculate churn rate on the basis of contract choosen
SELECT contract, churn, COUNT(*) AS total_customers,
ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY contract), 2) AS churn_rate_per_contract
FROM customer_churn_staging2
GROUP BY contract, churn
ORDER BY contract, churn;

