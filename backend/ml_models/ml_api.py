from flask import Flask, jsonify, request
from flask_cors import CORS
import os
import sys
import joblib
import pandas as pd
import numpy as np
from datetime import datetime
import warnings
warnings.filterwarnings('ignore')
import crops
app = Flask(__name__)
from flask_cors import CORS

app = Flask(__name__)

# CORS(app, resources={
#     r"/api/*": {
#         "origins": ["http://localhost:3000"],
#         "methods": ["GET", "POST"],
#         "allow_headers": ["Content-Type"]
#     }
# }) 
# CORS(app)

CORS(app, resources={r"/*": {"origins": "*"}})
BASE_PRICES = crops.base_price

MODEL_DIR = "../models_rf_forecast"
RAINFALL = [70, 21, 28, 46, 91, 211, 311, 275, 194, 103, 50, 24]

def load_model(crop_name):
    path = os.path.join(MODEL_DIR, f"{crop_name}.pkl")
    return joblib.load(path)

def predict_price(model, month, year, rainfall):
    input_data = pd.DataFrame([[month, year, rainfall]], columns=["Month", "Year", "Rainfall"])
    return model.predict(input_data)[0]

@app.route('/api/top5', methods=['GET'])
def top5():
    top_gainers = TopFiveWinners()
    return jsonify(top_gainers)

@app.route('/api/bottom5', methods=['GET'])
def bottom5():
    bottom_losers = TopFiveLosers()
    return jsonify(bottom_losers)

@app.route('/api/sixmonths', methods=['GET'])
def six_months():
    data = SixMonthsForecast()
    return jsonify(data)

@app.route('/api/previous/<name>', methods=['GET'])
def previous_twelve_months(name):
    prev_crop_values = TwelveMonthPrevious(name)
    return jsonify(prev_crop_values)

@app.route('/api/current/<name>', methods=['GET'])
def current_month_price(name):
    current_price = CurrentMonth(name)
    return jsonify({"current_price": current_price})

@app.route('/api/twelvemonths/<name>', methods=['GET'])
def twelve_months(name):
    max_crop, min_crop, forecast_crop_values = TwelveMonthsForecast(name)
    return jsonify({
        "max_crop": max_crop,
        "min_crop": min_crop,
        "forecast_values": forecast_crop_values
    })

@app.route('/api/commodity/<name>', methods=['GET'])
def commodity_data(name):
    max_crop, min_crop, forecast_crop_values = TwelveMonthsForecast(name)
    prev_crop_values = TwelveMonthPrevious(name)
    current_price = CurrentMonth(name)
    
    crop_data = crops.crop(name)  
    
    return jsonify({
        "name": name,
        "max_crop": max_crop,
        "min_crop": min_crop,
        "forecast_values": forecast_crop_values,
        "previous_values": prev_crop_values,
        "current_price": current_price,
        "image_url": crop_data[0],
        "prime_loc": crop_data[1],
        "type_c": crop_data[2],
        "export": crop_data[3]
    })


def TopFiveWinners():
    return top_5_gainers()

def TopFiveLosers():
    return top_5_losers()

def SixMonthsForecast():
    all_crops_forecast = []
    
    for crop in BASE_PRICES:
        try:
            forecast = forecast_next_12_months(crop)[:6]  # Only take first 6 months
            all_crops_forecast.append((crop, forecast))
        except:
            continue
    result = []
    for month_idx in range(6):
        month_data = []
        for crop, forecast in all_crops_forecast:
            if month_idx < len(forecast):
                month_data.append({
                    'crop': crop,
                    'price': forecast[month_idx][1],
                    'change': forecast[month_idx][2]
                })
        
        month_data_sorted = sorted(month_data, key=lambda x: x['price'])
        
        if month_data_sorted:
            result.append({
                'month': forecast[month_idx][0],  # Month label
                'max_crop': month_data_sorted[-1]['crop'],
                'max_price': month_data_sorted[-1]['price'],
                'max_change': month_data_sorted[-1]['change'],
                'min_crop': month_data_sorted[0]['crop'],
                'min_price': month_data_sorted[0]['price'],
                'min_change': month_data_sorted[0]['change']
            })
    
    return result

def TwelveMonthPrevious(name):
    return last_year_trend(name)

def CurrentMonth(name):
    return current_price(name)

def TwelveMonthsForecast(name):
    forecast = forecast_next_12_months(name)
    
    if not forecast:
        return None, None, []
    
    # Find max and min months
    max_month = max(forecast, key=lambda x: x[1])
    min_month = min(forecast, key=lambda x: x[1])
    
    return max_month, min_month, forecast

def current_price(crop_name):
    try:
        model = load_model(crop_name)
        month = datetime.now().month
        year = datetime.now().year
        rain = RAINFALL[month - 1]
        wpi = predict_price(model, month, year, rain)
        return round((wpi * BASE_PRICES[crop_name]) / 100, 2)
    except Exception as e:
        print(f"Error in current_price for {crop_name}: {e}")
        return 0

def forecast_next_12_months(crop_name):
    try:
        model = load_model(crop_name)
        now = datetime.now()
        month, year = now.month, now.year
        base_price = BASE_PRICES[crop_name]
        forecasts = []
        current_rain = RAINFALL[month - 1]
        current_wpi = predict_price(model, month, year, current_rain)

        for i in range(1, 13):
            future_month = (month + i - 1) % 12 + 1
            future_year = year if (month + i) <= 12 else year + 1
            rain = RAINFALL[future_month - 1]
            wpi = predict_price(model, future_month, future_year, rain)
            price = round((wpi * base_price) / 100, 2)
            change = round((wpi - current_wpi) * 100 / current_wpi, 2)
            label = datetime(future_year, future_month, 1).strftime("%b %y")
            forecasts.append([label, price, change])

        return forecasts
    except Exception as e:
        print(f"Error in forecast_next_12_months for {crop_name}: {e}")
        return []

def last_year_trend(crop_name):
    try:
        path = f"../static/dataset/{crop_name.capitalize()}.csv"
        df = pd.read_csv(path)
        df_2024 = df[df['Year'] == 2024]
        df_2024 = df_2024.sort_values(by="Month")

        base_price = BASE_PRICES[crop_name]
        values = []

        for _, row in df_2024.iterrows():
            month = int(row["Month"])
            wpi = row["WPI"]
            price = round((wpi * base_price) / 100, 2)
            label = datetime(2024, month, 1).strftime("%b %y")
            values.append([label, price])

        return values
    except Exception as e:
        print(f"Error in last_year_trend for {crop_name}: {e}")
        return []

def top_5_gainers():
    now = datetime.now()
    month, year = now.month, now.year
    prev_month = month - 1 if month > 1 else 12
    prev_year = year if month > 1 else year - 1

    changes = []
    for crop in BASE_PRICES:
        try:
            model = load_model(crop)
            wpi_now = predict_price(model, month, year, RAINFALL[month - 1])
            wpi_prev = predict_price(model, prev_month, prev_year, RAINFALL[prev_month - 1])
            change = ((wpi_now - wpi_prev) * 100) / wpi_prev
            price = round((wpi_now * BASE_PRICES[crop]) / 100, 2)
            changes.append((change, crop, price))
        except Exception as e:
            print(f"Error in top_5_gainers for {crop}: {e}")

    top = sorted(changes, reverse=True)[:5]
    return [(crop, price, f"{change:.2f}") for change, crop, price in top]

def top_5_losers():
    now = datetime.now()
    month, year = now.month, now.year
    prev_month = month - 1 if month > 1 else 12
    prev_year = year if month > 1 else year - 1

    changes = []
    for crop in BASE_PRICES:
        try:
            model = load_model(crop)
            wpi_now = predict_price(model, month, year, RAINFALL[month - 1])
            wpi_prev = predict_price(model, prev_month, prev_year, RAINFALL[prev_month - 1])
            change = ((wpi_now - wpi_prev) * 100) / wpi_prev
            price = round((wpi_now * BASE_PRICES[crop]) / 100, 2)
            changes.append((change, crop, price))
        except Exception as e:
            print(f"Error in top_5_losers for {crop}: {e}")

    bottom = sorted(changes)[:5]
    return [(crop, price, f"{change:.2f}") for change, crop, price in bottom]

# Load model and label encoder for fertilizer prediction
fertilizer_model = joblib.load("fertilizer_recommendation.joblib")
fertilizer_encoder = joblib.load("label_encoder_fertilizer.joblib")

# Fertilizer prediction function
def predict_fertilizer(soil_type, crop_type, N, P, K):
    input_data = pd.DataFrame([[soil_type, crop_type, N, P, K]],
                              columns=['Soil_Type', 'Crop_Type', 'N', 'P', 'K'])
    prediction = fertilizer_model.predict(input_data)
    return fertilizer_encoder.inverse_transform(prediction)[0]

# Define the route for fertilizer prediction
@app.route('/predict-fertilizer', methods=['POST'])
def predict_fertilizer_route():
    try:
        data = request.get_json()

        soil_type = int(data['soilType'])
        crop_type = int(data['cropType'])
        N = float(data['N'])
        P = float(data['P'])
        K = float(data['K'])

        result = predict_fertilizer(soil_type, crop_type, N, P, K)
        return jsonify({'fertilizer': result})

    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
# Load model and label encoder for crop prediction
crop_model = joblib.load("random_forest_cr.joblib")
crop_encoder = joblib.load("label_encoder_cr.joblib")

# Crop prediction function
def predict_crop(N, P, K, temperature, humidity, ph, rainfall):
    input_data = pd.DataFrame([[N, P, K, temperature, humidity, ph, rainfall]], 
                              columns=['N', 'P', 'K', 'temperature', 'humidity', 'ph', 'rainfall'])
    prediction = crop_model.predict(input_data)
    return crop_encoder.inverse_transform(prediction)[0]

# Define the route for crop prediction
@app.route('/predict', methods=['POST'])
def predict_crop_route():
    try:
        data = request.get_json()

        N = float(data['N'])
        P = float(data['P'])
        K = float(data['K'])
        temperature = float(data['temperature'])
        humidity = float(data['humidity'])
        ph = float(data['ph'])
        rainfall = float(data['rainfall'])

        result = predict_crop(N, P, K, temperature, humidity, ph, rainfall)
        return jsonify({'crop': result})

    except Exception as e:
        return jsonify({'error': str(e)}), 500


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=True)