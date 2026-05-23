import numpy as np
import pandas as pd
import streamlit as st
import pickle

#load the saved trained model
with open("models/trained_model.sav", "rb") as f:
    loaded_trained_model = pickle.load(f)
    
with open("models/label_encoder.sav", "rb") as f:
    loaded_label_encoded_model = pickle.load(f)
    
with open("models/one_hot_encoder.sav", "rb") as f:
    loaded_one_hot_encoder_model = pickle.load(f)
    
with open("models/standardscaler.sav", "rb") as f:
    loaded_scaler_model = pickle.load(f)

# Define numerical features
num_cols = ['tenure', 'senior_citizen', 'monthly_charges', 'total_charges']

# Define categorical feature groups
cats_col = ['gender', 'partner', 'dependents', 'phone_service', 'multiple_lines', 'internet_service', 'online_security', 'online_backup', 'device_protection', 'streaming_tv', 'streaming_movies', 'contract', 'paper_less_billing', 'payment_method']

def main():

    gender = st.selectbox("Select Gender", ["Male", "Female"])
    senior_citizen = st.selectbox("Are You Above 60 Years Old?", ["Yes", "No"])
    partner = st.selectbox("Are you married?", ["Yes", "No"])
    dependents = st.selectbox("Do you have dependents?", ["Yes", "No"])
    tenure = st.number_input("How long have you have the tenure?", min_value = 0, max_value=72)
    multiple_lines = st.selectbox("Do you have multiple lines?", ["Yes", "No", "No phone service"])
    internet_service = st.selectbox("Which internet service do you have?", ["DSL", "Fiber Optic", "No phone service"])
    online_security = st.selectbox("Do you have online security?", ["Yes", "No"])
    online_backup = st.selectbox("Do you have online backup?", ["Yes", "No"])
    device_protection = st.selectbox("Do you have device protection?", ["Yes", "No"])
    contract = st.selectbox("Select Your Contract Type", ["Month-to-month", "One year", "Two year"])
    paper_less_billing = ("Do prefer paper less billing?", ["Yes", "No"])
    payment_method = st.selectbox("Select your payment method?", ["Yes", "No"])
    monthly_charges = st.number_input("Enter Your monthly charges?", min_value = 0.0, max_value=200.0, value=50.0, step = 1.0)
    total_charges = st.number_input("Enter Your total charges?", min_value = 0.0, max_value=10000, step=10.0)
    total_services = st.number_input("Enter how many servicews you have subscribed to?", min_value = 0, max_value=10, value=0, step=1)

 