import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestRegressor
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import make_pipeline
import joblib
import os
import crops


CROP_PATHS = crops.crop_path
MODEL_DIR = "models_rf"
os.makedirs(MODEL_DIR, exist_ok=True)

class CropModel:
    def __init__(self, crop_name, csv_path):
        self.name = crop_name
        self.csv_path = csv_path
        self.model = None
        self.scaler = None
        self._load_data()
        self._train_model()

    def _load_data(self):
        df = pd.read_csv(self.csv_path)
        self.X = df.iloc[:, :-1].values 
        self.y = df.iloc[:, 3].values    # wpi

    def _train_model(self):
        self.model = make_pipeline(StandardScaler(), RandomForestRegressor(n_estimators=150, max_depth=15, random_state=42))
                                                                            #150 decision trees Depth-15 to prevent overfitting
        self.model.fit(self.X, self.y)
        joblib.dump(self.model, f"{MODEL_DIR}/{self.name}.pkl")
        print(f"Model for '{self.name}' saved.")
        
    def predict(self, month, year, rainfall):
        X_test = np.array([[month, year, rainfall]])
        return self.model.predict(X_test)[0]


crop_models = {}
for name, path in CROP_PATHS.items():
    crop_models[name] = CropModel(name, path)
