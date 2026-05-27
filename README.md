# Telco Customer Churn Project

## Overview
Built an end to end Data Science and Machine Learning project anayzing 7000+ telco customers by predicting the churn status of customers who are likely or have churned or they have not churned based on customer's demographics, subscribed services, revenues, tenure and contract. The project covers the data science workflow = from SQL data cleaning and EDA, to Python visualization, ML modeling

## Dataset
- **Source:** Kaggle - [Telco Customer Churn Dataset] (https://www.kaggle.com/datasets/blastchar/telco-customer-churn)
- **Records:** 7000+ customers
- **Features:** 21 columns
- **Key Columns:** Churn, Contract, Tenure, InterntService, PaymentMethod, MonthlyCharge, TotalCharge 

## Project Workflow 
Raw Data → SQL Data Cleaning → SQL EDA → Python EDA → ML Model → Streamlit App

## Model Result

|           Metric                              | Score  |
|-----------------------------------------------|--------|
| Logistic Regression CV Accuracy Score         | 0.75   |
| Logistic Regression CV F1 Score               | 0.63   | 
| Random Forest Classifier CV Accuracy Score    | 0.78   |
| Random Forest Classifier CV F1 Score          | 0.59   | 
| Decision Tree Classifier CV Accuracy Score    | 0.72   |
| Decision Tree Classifier CV F1 Score          | 0.51   | 
| XGBRF Classifier CV Accuracy Score            | 0.77   |
| XGBRF Classifier CV F1 Score                  | 0.63   | 
|-----------------------------------------------|--------|
| XGBRF Classifier After Tuning F1 Score        | 0.6233 | 
|-----------------------------------------------|--------|
| Final Test Accuracy                           | 0.7785 | 
| Final Test Precision (Churn)                  | 0.56   |
| Final Test Recall (Churn)                     | 0.76   |
| Final Test F1 Score (Churn)                   | 0.64   |

I compared four models with cross-validation accuracy score and F1 score and found that XGBRF Classifier performed the best, scoring 0.77 accuracy score and 0.63 F1 score. So, I selected it as a final model and performed hyperparameter tuning using GridSearchCV. After tuning, the F1 score remained stable at around 0.62-0.63 suggesting the default parameters were already near optimal. Finally, I evaluated the tuned model on unseen data using accuracy score and classification report. The confusion matrix confirmed the model correctly predicted the majority of churned customers while maintaining strong overall accuracy.

## Key Decisions

1. **Seleced XGBFR Classifier As Final odel:** After comparing the four models (Logistic Regression, Random Forest Classifier, Decision Tree, XGBRF Classifier), XGBRF Classifier was selected as the final model due to high cross-validation accuracy and F1 score. 

2. **Handling Class Imbalance and Overfitting:** SMOTE (Synthetic Minority Oversampling Technique) was selected inside pipeline to handle the class imbalance in churn data and hanlde overfitting of the data, preventing data leakage during cross-validation.

3. **Evaluation Metric:** F1 score was given more significance over accuracy because the dataset is imbalanced and accuracy score alone can be misleading when one class dominates the dataset.

4. **Feature Engineering:** 
Created additional four features: 
- **tenure_groups** - grouped tenure into time periods for better trend analysis 
- **total_services** -  counted total services per customer to analyze if multiple services reduces churn rates
- **customer_profile** -  combined partners and dependents to find if customers with family churned more or less
- **churn_numeric** - converted churn to 0/1 for correlation analysis

5. **Drop Columns:** - Dropped customer_id column, tenure_groups customer_profile and churn_numeric before modeling to prevent data leakage and remove redundant features.

## Business Recommendations
1. Encourage month-to-month customers to upgrade to annual contracts through discounts and offers.
2. Investigate why fiber optics internet service customers churned more, the causes might be pricing or the service itself.
3. Promote automatic payments methods than electronic check as the automatic services had low churn rates.
4. Customers with multiple services churned less, so customers should be provided with multiple services.

# Dashboard Preview
![Screenshot of Streamlit Dashboard Tab] (apps-image/dashboard-image)
![Screenshot of Streamlit Prediction Tab] (apps-image/prediction-image)

## Tech Stack
- **MySQL** - Data Cleaning & EDA
- **Python** - Data Analysis & ML
- **Pandas** - Data Manipulation
- **Matplotlib & Seaborn** - Data Visualization
- **Scikit-learn** - Machine Learning 
- **Pickle** - Save Models
- **Plotly** - Interactive Charts
- **Streamlit** - Dashboard, Prediction System & Deployment

## Quick Start
```bash
git clone https://github.com/shlokzz/Customer-Churn-Prediction-Project.git
pip install -r requirements.txt
streamlit run apps/app.py
```

## Project Structure
```
sql/                # Data Cleaning and EDA
notebooks/          # Visual EDA and Model Evaluation
dataset/            # Raw and Clean Dataset
apps/               # Streamlit Web Application
apps-image/         # Image of Streamlit App
models/             # Saved Models
```
