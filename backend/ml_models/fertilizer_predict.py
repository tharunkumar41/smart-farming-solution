import sys
import joblib
import pandas as pd

# Load model and label encoder
best_model_name = "../backend/ml_models/fertilizer_recommendation.joblib"
model = joblib.load(best_model_name)
encoder = joblib.load("../backend/ml_models/label_encoder_fertilizer.joblib")

def predict_fertilizer(soil_type, crop_type, N, P, K):
    """Predicts the best fertilizer based on soil, crop, and nutrients."""
    input_data = pd.DataFrame([[soil_type, crop_type, N, P, K]],
                              columns=['Soil_Type', 'Crop_Type', 'N', 'P', 'K'])
    prediction = model.predict(input_data)
    return encoder.inverse_transform(prediction)[0]

if __name__ == "__main__":
    if len(sys.argv) != 6:
        print("Error: Expected 5 inputs - soil_type, crop_type, N, P, K")
        sys.exit(1)

    try:
        soil_type = int(sys.argv[1])
        crop_type = int(sys.argv[2])
        N = float(sys.argv[3])
        P = float(sys.argv[4])
        K = float(sys.argv[5])

        result = predict_fertilizer(soil_type, crop_type, N, P, K)
        print(result)
        sys.stdout.flush()

    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)
