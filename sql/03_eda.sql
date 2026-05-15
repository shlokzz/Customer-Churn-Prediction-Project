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

-- Calculate churn rates across gender demographics 
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

-- Identify churn on the basis of tenure group and contract type
SELECT 
CASE
	WHEN tenure <= 12
		THEN '0-1 Year'
	WHEN tenure <= 24
		THEN '1-2 Years'
	WHEN tenure <= 48
		THEN '2-4 Years'
	WHEN tenure <= 72
		THEN '4-6 Year'
	ELSE
		'Over 6 Years'
END AS tenure_group,
churn, contract, COUNT(*) AS total_customers,
ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY contract), 2) AS churn_rate_per_contract
FROM customer_churn_staging2
GROUP BY 1,2,3
ORDER BY 1,2,3;

-- Analyze average tenure, monthly charges and total_charges by churn status
SELECT churn, ROUND(AVG(tenure),2) AS avg_tenure, 
ROUND(AVG(monthly_charges),2) AS avg_monthly_charges, 
ROUND(MAX(monthly_charges)) AS max_monthly_charges,
ROUND(AVG(total_charges),2) AS avg_total_charges
FROM customer_churn_staging2
GROUP BY churn;
