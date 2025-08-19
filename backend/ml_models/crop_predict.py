import sys
import joblib
import pandas as pd

# Load the model and label encoder
best_model_name = "../backend/ml_models/random_forest_cr.joblib"
model = joblib.load(best_model_name)
encoder = joblib.load("../backend/ml_models/label_encoder_cr.joblib")

def predict_crop(N, P, K, temperature, humidity, ph, rainfall):
    """Predicts the crop type based on input soil and climate conditions."""
    input_data = pd.DataFrame([[N, P, K, temperature, humidity, ph, rainfall]], 
                              columns=['N', 'P', 'K', 'temperature', 'humidity', 'ph', 'rainfall'])
    prediction = model.predict(input_data)
    return encoder.inverse_transform(prediction)[0]

if __name__ == "__main__":
    # Ensure correct number of arguments
    if len(sys.argv) != 8:
        print("Error: Invalid number of inputs")
        sys.exit(1)
    
    try:
        # Convert arguments to float
        N, P, K, temperature, humidity, ph, rainfall = map(float, sys.argv[1:])
        
        # Predict crop
        result = predict_crop(N, P, K, temperature, humidity, ph, rainfall)
        
        # Print result for Node.js to capture
        print(result)
        sys.stdout.flush()

    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)
