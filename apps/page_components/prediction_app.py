import numpy as np
import pandas as pd
import streamlit as st
import pickle

@st.cache_resource
def save_model():
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

    return loaded_final_pipeline, loaded_label_encoded_model, loaded_one_hot_encoder_model, loaded_scaler_model, loaded_model_columns,

loaded_final_pipeline, loaded_label_encoded_model, loaded_one_hot_encoder_model, loaded_scaler_model, loaded_model_columns = save_model()

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
    "tech_support",
    "streaming_tv",
    "streaming_movies",
    "contract",
    "paper_less_billing",
    "payment_method",
]


def show():
    def customer_churn_prediction(input_data):

        # convert inputs as a pandas DataFrame
        input_data_as_dataframe = pd.DataFrame([input_data])

        # use the saved OneHotEncoder model
        one_hot_encoder_data = loaded_one_hot_encoder_model.transform(
            input_data_as_dataframe[cats_col]
        )
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
        return prediction

    def main():

        # Page header
        st.title("Customer Churn Predictor")
        st.divider()

        # Customer Demographics
        st.subheader("Customer Demographics")
        col1, col2, col3 = st.columns(3)

        with col1:
            gender = st.selectbox("Select Gender", ["Male", "Female"])

        with col2:
            senior_citizen_ui = st.selectbox(
                "Are You Above 60 Years Old?", ["Yes", "No"]
            )
            senior_citizen = 1 if senior_citizen_ui == "Yes" else 0

        with col3:
            partner = st.selectbox("Are you married?", ["Yes", "No"])

        col4, col5 = st.columns(2)

        with col4:
            dependents = st.selectbox("Do you have dependents?", ["Yes", "No"])

        with col5:
            tenure = st.number_input(
                "How long have you have the tenure?", min_value=0, max_value=72, step=1
            )

        st.divider()

        # Services
        st.subheader("Subscribed Services")
        col1, col2, col3 = st.columns(3)

        with col1:
            phone_service = st.selectbox("Do you have a phone service?", ["Yes", "No"])
            multiple_lines = st.selectbox(
                "Do you have multiple lines?", ["Yes", "No", "No phone service"]
            )
            internet_service = st.selectbox(
                "Which internet service do you have?",
                ["DSL", "Fiber Optic", "No"],
            )

        with col2:
            online_security = st.selectbox(
                "Do you have online security?", ["Yes", "No", "No internet service"]
            )
            online_backup = st.selectbox(
                "Do you have online backup?", ["Yes", "No", "No internet service"]
            )
            device_protection = st.selectbox(
                "Do you have device protection?", ["Yes", "No", "No internet service"]
            )

        with col3:
            tech_support = st.selectbox(
                "Do you have tech support?", ["Yes", "No", "No internet service"]
            )
            streaming_tv = st.selectbox(
                "Do you stream in TV?", ["Yes", "No", "No internet service"]
            )
            streaming_movies = st.selectbox(
                "Do you stream movies?", ["Yes", "No", "No internet service"]
            )

        st.divider()

        # Revenues and contract

        st.subheader("Contract & Revenue")

        col1, col2, col3 = st.columns(3)
        with col1:
            contract = st.selectbox(
                "Select Your Contract Type", ["Month-to-month", "One year", "Two year"]
            )

        with col2:
            paper_less_billing = st.selectbox(
                "Do you prefer paper less billing?", ["Yes", "No"]
            )

        with col3:
            payment_method = st.selectbox(
                "Select your payment method?",
                [
                    "Bank transfer (automatic)",
                    "Credit card (automatic)",
                    "Electronic check",
                    "Mailed check",
                ],
            )

        col4, col5 = st.columns(2)

        with col4:
            total_charges = st.number_input(
                "Enter Your total charges?",
                min_value=0.0,
                max_value=10000.0,
                value=0.0,
                step=10.0,
            )
        with col5:
            monthly_charges = st.number_input(
                "Enter Your monthly charges?",
                min_value=0.0,
                max_value=200.0,
                value=0.0,
                step=1.0,
            )

        # code for prediction
        prediction = ""

        # creating button for prediction
        if st.button("Predict Churn Status"):

            inputs = {
                "gender": gender,
                "senior_citizen": senior_citizen,
                "partner": partner,
                "dependents": dependents,
                "tenure": tenure,
                "phone_service": phone_service,
                "multiple_lines": multiple_lines,
                "internet_service": internet_service,
                "online_security": online_security,
                "online_backup": online_backup,
                "device_protection": device_protection,
                "tech_support": tech_support,
                "streaming_tv": streaming_tv,
                "streaming_movies": streaming_movies,
                "contract": contract,
                "paper_less_billing": paper_less_billing,
                "payment_method": payment_method,
                "monthly_charges": monthly_charges,
                "total_charges": total_charges,
            }

            prediction = customer_churn_prediction(inputs)

            if prediction == 0:
                st.metric(label="Churn Prediction", value=False)
                st.success("The customer is predicted TO STAY")

            else:
                st.metric(label="Churn Prediction", value=True)
                st.error("The customer is predicted TO BE CHURNED.")

    main()
