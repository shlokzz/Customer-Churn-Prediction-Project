import streamlit as st
from page_components import dashboard_app, prediction_app

st.set_page_config(page_title="Customer Churn Analytical Dashboard & Prediction System", layout="wide")

st.title("Customer Churn Analyzer")

tab1, tab2 = st.tabs(['Dashboard','Prediction'])

with tab1:
    dashboard_app.show()

with tab2:
    prediction_app.show()