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

