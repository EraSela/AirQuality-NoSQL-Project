from pymongo import MongoClient
import pandas as pd

client = MongoClient("mongodb://localhost:27017/")
db = client["AirQualityMongo"]
collection = db["sensor_readings"]

data = list(collection.find())

df = pd.json_normalize(data)

df.to_csv("MongoSensorReadings.csv", index=False)

print("CSV exported successfully.")