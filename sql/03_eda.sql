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
SELECT churn, gender, COUNT(*) AS total_customers,
ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY gender), 2) AS percentage
FROM customer_churn_staging2
GROUP BY churn,gender
ORDER BY gender, churn;

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

-- Analyze average tenure, monthly charges and total charges by churn status
SELECT churn, ROUND(AVG(tenure),2) AS avg_tenure, 
ROUND(AVG(monthly_charges),2) AS avg_monthly_charges, 
ROUND(MAX(monthly_charges)) AS max_monthly_charges,
ROUND(AVG(total_charges),2) AS avg_total_charges
FROM customer_churn_staging2
GROUP BY churn;

-- Calculate churn rates on the basis of internet service type
SELECT churn, internet_service, COUNT(*) AS total_customers,
ROUND (COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY internet_service) ,2) as churn_rate_per_internet_service
FROM customer_churn_staging2
GROUP BY churn, internet_service
ORDER BY internet_service;

-- Calculate churn rates on the basis of paperless billing preference
SELECT churn, paper_less_billing, COUNT(*) AS total_customers,
ROUND (COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY paper_less_billing) ,2) as churn_rate_per_paper_less_billing
FROM customer_churn_staging2
GROUP BY churn, paper_less_billing
ORDER BY paper_less_billing;

-- Calculate churn rates across different payment method
SELECT churn, payment_method, COUNT(*) AS total_customers,
ROUND (COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY payment_method) ,2) as churn_rate_per_payment_method
FROM customer_churn_staging2
GROUP BY churn, payment_method
ORDER BY payment_method;

-- Calculate churn rates for senior citizens vs non-senior citizens
SELECT churn, senior_citizen, COUNT(*) AS total_customers,
ROUND (COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY senior_citizen) ,2) as churn_rate_per_senior_citizen
FROM customer_churn_staging2
GROUP BY churn, senior_citizen
ORDER BY senior_citizen;

-- Analyze 30 customers with the highest monthly charges 
SELECT customer_id, tenure, payment_method, monthly_charges, total_charges, contract 
FROM customer_churn_staging2
WHERE churn = 'Yes'
ORDER BY monthly_charges DESC
LIMIT 30;

-- Calculate the total number of services per customer on the basis of churn rates
SELECT 
	(
    CASE WHEN phone_service = 'Yes' THEN 1 ELSE 0 END +
    CASE WHEN multiple_lines = 'Yes' THEN 1 ELSE 0 END +
    CASE WHEN internet_service != 'No' THEN 1 ELSE 0 END +
    CASE WHEN online_security = 'Yes' THEN 1 ELSE 0 END +
    CASE WHEN online_backup = 'Yes' THEN 1 ELSE 0 END +
    CASE WHEN device_protection = 'Yes' THEN 1 ELSE 0 END +
    CASE WHEN tech_support = 'Yes' THEN 1 ELSE 0 END +
    CASE WHEN streaming_tv = 'Yes' THEN 1 ELSE 0 END +
    CASE WHEN streaming_movies = 'Yes' THEN 1 ELSE 0 END) AS total_services,
churn, COUNT(*) AS total_customers
FROM customer_churn_staging2
GROUP BY 1,2
ORDER BY 1;
