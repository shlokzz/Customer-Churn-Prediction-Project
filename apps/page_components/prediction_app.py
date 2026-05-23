import numpy as np
import pandas as pd
import streamlit as st
import pickle

# load the saved trained model
with open("models/final_pipeline.sav", "rb") as f:
    loaded_final_pipeline = pickle.load(f)

with open("models/label_encoder.sav", "rb") as f:
    loaded_label_encoded_model = pickle.load(f)

with open("models/one_hot_encoder.sav", "rb") as f:
    loaded_one_hot_encoder_model = pickle.load(f)

with open("models/standardscaler.sav", "rb") as f:
    loaded_scaler_model = pickle.load(f)

with open("models/model_columns.sav", "rb") as f:
    loaded_model_columns = pickle.load(f)

# Define numerical features
num_cols = ["tenure", "senior_citizen", "monthly_charges", "total_charges"]

# Define categorical feature groups
cats_col = [
    "gender",
    "partner",
    "dependents",
    "phone_service",
    "multiple_lines",
    "internet_service",
    "online_security",
    "online_backup",
    "device_protection",
    "streaming_tv",
    "streaming_movies",
    "contract",
    "paper_less_billing",
    "payment_method",
]


def customer_churn_prediction(input_data):

    # convert inputs as a pandas DataFrame
    input_data_as_dataframe = pd.DataFrame([input_data])

    # use the saved LabelEncoder
    label_encoder_data = loaded_label_encoded_model.transform(input[cats_col])

    # use the saved OneHotEncoder model
    one_hot_encoder_data = loaded_one_hot_encoder_model.transform(input[cats_col])
    one_hot_encoder_df = pd.DataFrame(
        one_hot_encoder_data,
        columns=loaded_one_hot_encoder_model.get_feature_names_out(cats_col),
    )

    # use the saved StandardScaler
    std_data = loaded_scaler_model.transform(input_data_as_dataframe[num_cols])
    std_df = pd.DataFrame(std_data, columns=num_cols)

    # concatenate StandardScaler and OneHotEncoder
    final_input = pd.concat(
        [one_hot_encoder_df.reset_index(drop=True), std_df.reset_index(drop=True)],
        axis=1,
    )

    # Reindex to match the training column names in exact order
    final_input = final_input.reindex(columns=loaded_model_columns, fill_value=0)

    prediction = loaded_final_pipeline.predict(final_input)
    return f"{prediction}"


def main():

    gender = st.selectbox("Select Gender", ["Male", "Female"])
    senior_citizen = st.selectbox("Are You Above 60 Years Old?", ["Yes", "No"])
    partner = st.selectbox("Are you married?", ["Yes", "No"])
    dependents = st.selectbox("Do you have dependents?", ["Yes", "No"])
    tenure = st.number_input(
        "How long have you have the tenure?", min_value=0, max_value=72
    )
    multiple_lines = st.selectbox(
        "Do you have multiple lines?", ["Yes", "No", "No phone service"]
    )
    internet_service = st.selectbox(
        "Which internet service do you have?",
        ["DSL", "Fiber Optic", "No phone service"],
    )
    online_security = st.selectbox("Do you have online security?", ["Yes", "No"])
    online_backup = st.selectbox("Do you have online backup?", ["Yes", "No"])
    device_protection = st.selectbox("Do you have device protection?", ["Yes", "No"])
    contract = st.selectbox(
        "Select Your Contract Type", ["Month-to-month", "One year", "Two year"]
    )
    paper_less_billing = ("Do prefer paper less billing?", ["Yes", "No"])
    payment_method = st.selectbox("Select your payment method?", ["Yes", "No"])
    monthly_charges = st.number_input(
        "Enter Your monthly charges?",
        min_value=0.0,
        max_value=200.0,
        value=50.0,
        step=1.0,
    )
    total_charges = st.number_input(
        "Enter Your total charges?", min_value=0.0, max_value=10000, step=10.0
    )
    total_services = st.number_input(
        "Enter how many servicews you have subscribed to?",
        min_value=0,
        max_value=10,
        value=0,
        step=1,
    )

    # code for prediction
    prediction = ""

    # creating button for prediction
    if st.button("Predict Churn Status"):

        inputs = {
            "gender": gender,
            "senior_citzen": senior_citizen,
            "partner": partner,
            "dependents": dependents,
            "tenure": tenure,
            "multiple_lines": multiple_lines,
            "internet_service": internet_service,
            "online_security": online_security,
            "online_backup": online_backup,
            "device_protection": device_protection,
            "contract": contract,
            "paper_less_billing": paper_less_billing,
            "payment_method": payment_method,
            "monthly_charges": monthly_charges,
            "total_charges": total_charges,
            "total_services": total_services,
        }

        if prediction == 0:
            st.metric(label="Churn Prediction", value=False)
            st.success("The customer is predicted to STAY")

        else:
            st.metric(label="Churn Prediction", value=True)
            st.error("The customer is predicted To Be CHURNED.")

main()
