import numpy as np
import pandas as pd
import streamlit as st
import matplotlib.pyplot as plt
import plotly.express as px

df = pd.read_csv("dataset/clean dataset/final_telco_customer_churn_cleaned_dataset.csv")

st.set_page_config(layout="wide")
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
select_gender = st.sidebar.multiselect(
    "Select Gender",
    options=sorted(df["gender"].dropna().unique().tolist()),
    default=df["gender"].dropna().unique().tolist(),
    key="dashboard_gender",
)

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
    key="dashboard_internet_service",
)

# Apply Filters
filtered_df = df[
    df["churn"].isin(select_churn_status)
    & (df["gender"].isin(select_gender))
    & (df["contract"].isin(select_contract))
    & (df["tenure_groups"].isin(select_tenure))
    & (df["payment_method"].isin(select_payment_method))
    & (df["internet_service"].isin(select_internet_service))
]

st.subheader("Overview")
# Columns layout
col1, col2, col3, col4, col5 = st.columns(5)

total_customers = len(filtered_df)
total_churned = int(filtered_df["churn_numeric"].sum())
total_retained = total_customers - total_churned
churn_rate = (total_churned / total_customers) * 100 if total_customers > 0 else 0.0
monthly_revenue_lost = filtered_df[filtered_df["churn"] == "Yes"][
    "monthly_charges"
].sum()

# Display KPI cards
col1.metric("Total Customer", value=f"{total_customers:,}")
col2.metric(
    "Total Churned", value=f"{total_churned:,}", delta="-Loss", delta_color="inverse"
)
col3.metric("Total Retained", value=f"{total_retained:,}")
col4.metric("Total Churn Rate", value=f"{churn_rate:.2f}%")
col5.metric(
    "Monthly Revenue at Risk",
    value=f"${monthly_revenue_lost:,.2f}",
    delta="-Revenue Loss",
    delta_color="inverse",
)

# Display barchart for gender demographics
st.subheader("Churn Rates By Gender Demographics")

gender_counts = (
    filtered_df.groupby(["gender", "churn"]).size().reset_index(name="Customer Count")
)

fig = px.bar(
    gender_counts,
    x="gender",
    y="Customer Count",
    color="churn",
    barmode="group",
    color_discrete_map={"No": "orange", "Yes": "blue"},
    labels={
        "gender": "Gender",
        "churn": "Churn Status",
    },
)

st.plotly_chart(fig, width="stretch")

col1, col2 = st.columns(2)

with col1:

    # Display barchart for tenure groups
    st.subheader("Churn Rates By Tenure Groups")

    contract_type = (
        filtered_df.groupby(["tenure_groups", "churn"])
        .size()
        .reset_index(name="Customer Count")
    )

    fig = px.bar(
        contract_type,
        x="tenure_groups",
        y="Customer Count",
        color="churn",
        barmode="group",
        color_discrete_map={"No": "orange", "Yes": "blue"},
        labels={
            "tenure_groups": "Tenure Groups",
            "churn": "Churn Status",
        },
    )

    st.plotly_chart(fig, width="stretch")

    # Display barchart for contract type
    st.subheader("Churn Rates By Contract Type")

    contract_type = (
        filtered_df.groupby(["contract", "churn"])
        .size()
        .reset_index(name="Customer Count")
    )

    fig = px.bar(
        contract_type,
        x="contract",
        y="Customer Count",
        color="churn",
        barmode="group",
        color_discrete_map={"No": "orange", "Yes": "blue"},
        labels={
            "contract": "Contract Type",
            "churn": "Churn Status",
        },
    )

    st.plotly_chart(fig, width="stretch")

    # Display barchart for internet service
    st.subheader("Churn Rates By Internet Service")

    internet_service = (
        filtered_df.groupby(["internet_service", "churn"])
        .size()
        .reset_index(name="Customer Count")
    )

    fig = px.bar(
        internet_service,
        x="internet_service",
        y="Customer Count",
        color="churn",
        barmode="group",
        color_discrete_map={"No": "orange", "Yes": "blue"},
        labels={
            "internet_service": "Internet Service",
            "churn": "Churn Status",
        },
    )

    st.plotly_chart(fig, width="stretch")

with col2:
    # Display histogram for monthly revenue
    st.subheader("Churn Rates By Monthly Revenue")

    fig = px.histogram(
        filtered_df,
        x="monthly_charges",
        color="churn",
        barmode="group",
        nbins=20,
        color_discrete_map={"No": "orange", "Yes": "blue"},
        labels={
            "monthly_charges": "Monthly Revenue",
            "churn": "Churn Status",
        },
        title="Are Churned Customers Paying More?",
    )
    fig.update_layout(yaxis_title="Number of Customers")
    st.plotly_chart(fig, width="stretch")

    # Display bar chart for payment method
    st.subheader("Churn Rates By Customer's Payment Method")

    payment_method = (
        filtered_df.groupby(["payment_method", "churn"])
        .size()
        .reset_index(name="Customer Count")
    )

    fig = px.bar(
        payment_method,
        x="payment_method",
        y="Customer Count",
        color="churn",
        barmode="group",
        color_discrete_map={"No": "orange", "Yes": "blue"},
        labels={
            "payment_method": "Payment Method",
            "churn": "Churn Status",
        },
    )

    st.plotly_chart(fig, width="stretch")

    # Display barchart for contract type
    st.subheader("Churn Rates By Total Service")

    total_services = (
        filtered_df.groupby(["total_services", "churn"])
        .size()
        .reset_index(name="Customer Count")
    )

    fig = px.bar(
        total_services,
        x="total_services",
        y="Customer Count",
        color="churn",
        barmode="group",
        color_discrete_map={"No": "orange", "Yes": "blue"},
        labels={
            "total_services": "Total Services",
            "churn": "Churn Status",
        },
        title="Do Customers Churn With More Services Or Less?"
    )

    st.plotly_chart(fig, width="stretch")
