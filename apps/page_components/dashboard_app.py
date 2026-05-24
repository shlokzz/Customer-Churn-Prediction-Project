import numpy as np
import pandas as pd
import streamlit as st
import matplotlib.pyplot as plt
import plotly.express as px

df = pd.read_csv("dataset/clean dataset/final_telco_customer_churn_cleaned_dataset.csv")

# Add sidebar filters
st.sidebar.header("Dashboard Filters")
st.sidebar.caption("Filter Applies Only To Dashboard Tab")

# churn status filter
select_churn_status = st.sidebar.multiselect(
    "Select Churn Status",
    options=sorted(df["churn"].dropna().unique().tolist()),
    default=df["churn"].dropna().unique().tolist(),
    key="dashboard_churn",
)

# gender filter
select_gender = st.sidebar.selectbox("Select Gender", ["Male", "Female"])

# contract filter
select_contract = st.sidebar.multiselect(
    "Select Contract",
    options=sorted(df["contract"].dropna().unique().tolist()),
    default=df["contract"].dropna().unique().tolist(),
    key="dashboard_contract",
)

# tenure group filter
select_tenure = st.sidebar.multiselect(
    "Select Tenure Group",
    options=sorted(df["tenure_groups"].dropna().unique().tolist()),
    default=df["tenure_groups"].dropna().unique().tolist(),
    key="dashboard_tenure_groups",
)

# payment method filter
select_payment_method = st.sidebar.multiselect(
    "Select Payment Method",
    options=sorted(df["payment_method"].dropna().unique().tolist()),
    default=df["payment_method"].dropna().unique().tolist(),
    key="dashboard_payment_method",
)

# internet service filter
select_internet_service = st.sidebar.multiselect(
    "Select Internet Service",
    options=sorted(df["internet_service"].dropna().unique().tolist()),
    default=df["internet_service"].dropna().unique().tolist(),
    key="dashboar_internet_service",
)

# Apply Filters
filtered_df = df[
    df["churn"].isin(select_churn_status)
    & (df["contract"].isin(select_contract))
    & (df['tenure_groups'].isin(select_tenure)) 
    & (df['payment_method'].isin(select_payment_method)) 
]

st.subheader("Overview")
# Columns layout
col1, col2, col3, col4 = st.columns(4)

total_customers = len(filtered_df)
total_churned = int(filtered_df['churn_numeric'].sum())
total_retained = total_customers - total_churned
churn_rate = (total_churned/ total_customers) * 100 if total_customers > 0 else 0.0

# Display KPI cards
col1.metric("Total Customer", value=f"{total_customers:,}")
col2.metric("Total Churned", value=f"{total_churned:,}", delta="-Loss", delta_color="inverse")
col3.metric("Total Retained", value=f"{total_retained:,}")
col4.metric("Total Churn Rate", value=f"{churn_rate:.2f}%")