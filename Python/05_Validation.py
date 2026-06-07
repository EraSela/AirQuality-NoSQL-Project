import pyodbc
from pymongo import MongoClient
import hashlib

# -----------------------------
# SQL Server Connection
# -----------------------------
sql_conn = pyodbc.connect(
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=localhost;"
    "DATABASE=AirQualityDB;"
    "Trusted_Connection=yes;"
)

sql_cursor = sql_conn.cursor()

# -----------------------------
# MongoDB Connection
# -----------------------------
mongo_client = MongoClient("mongodb://localhost:27017/")
mongo_db = mongo_client["AirQualityMongo"]
collection = mongo_db["sensor_readings"]

print("========== DATA VALIDATION REPORT ==========\n")

# -----------------------------
# 1. Count Validation
# -----------------------------
sql_cursor.execute("SELECT COUNT(*) FROM SensorReadings")
sql_count = sql_cursor.fetchone()[0]

mongo_count = collection.count_documents({})

print("1. Record Count Validation")
print("SQL Rows:", sql_count)
print("Mongo Documents:", mongo_count)

if sql_count == mongo_count:
    print("PASS: Counts match\n")
else:
    print("FAIL: Counts do not match\n")

# -----------------------------
# 2. Average PM2.5 Validation
# -----------------------------
sql_cursor.execute("SELECT AVG(PM25) FROM SensorReadings")
sql_avg_pm25 = round(sql_cursor.fetchone()[0], 2)

mongo_avg_pm25 = list(collection.aggregate([
    {
        "$group": {
            "_id": None,
            "avgPM25": {
                "$avg": "$measurements.pm25"
            }
        }
    }
]))[0]["avgPM25"]

mongo_avg_pm25 = round(mongo_avg_pm25, 2)

print("2. Average PM2.5 Validation")
print("SQL AVG PM2.5:", sql_avg_pm25)
print("Mongo AVG PM2.5:", mongo_avg_pm25)

if sql_avg_pm25 == mongo_avg_pm25:
    print("PASS: Average PM2.5 matches\n")
else:
    print("FAIL: Average PM2.5 does not match\n")

# -----------------------------
# 3. Average Temperature Validation
# -----------------------------
sql_cursor.execute("SELECT AVG(Temperature) FROM SensorReadings")
sql_avg_temp = round(sql_cursor.fetchone()[0], 2)

mongo_avg_temp = list(collection.aggregate([
    {
        "$group": {
            "_id": None,
            "avgTemperature": {
                "$avg": "$measurements.temperature"
            }
        }
    }
]))[0]["avgTemperature"]

mongo_avg_temp = round(mongo_avg_temp, 2)

print("3. Average Temperature Validation")
print("SQL AVG Temperature:", sql_avg_temp)
print("Mongo AVG Temperature:", mongo_avg_temp)

if sql_avg_temp == mongo_avg_temp:
    print("PASS: Average Temperature matches\n")
else:
    print("FAIL: Average Temperature does not match\n")

# -----------------------------
# 4. Average Humidity Validation
# -----------------------------
sql_cursor.execute("SELECT AVG(Humidity) FROM SensorReadings")
sql_avg_humidity = round(sql_cursor.fetchone()[0], 2)

mongo_avg_humidity = list(collection.aggregate([
    {
        "$group": {
            "_id": None,
            "avgHumidity": {
                "$avg": "$measurements.humidity"
            }
        }
    }
]))[0]["avgHumidity"]

mongo_avg_humidity = round(mongo_avg_humidity, 2)

print("4. Average Humidity Validation")
print("SQL AVG Humidity:", sql_avg_humidity)
print("Mongo AVG Humidity:", mongo_avg_humidity)

if sql_avg_humidity == mongo_avg_humidity:
    print("PASS: Average Humidity matches\n")
else:
    print("FAIL: Average Humidity does not match\n")

# -----------------------------
# 5. Hash Validation on Key Fields
# -----------------------------
sql_cursor.execute("""
SELECT TOP 1000
    ReadingID,
    PM25,
    PM10,
    ReadingTime
FROM SensorReadings
ORDER BY ReadingID
""")

sql_rows = sql_cursor.fetchall()

sql_hash_string = ""

for row in sql_rows:
    sql_hash_string += f"{row.ReadingID}-{row.PM25}-{row.PM10}-{row.ReadingTime};"

sql_hash = hashlib.md5(sql_hash_string.encode()).hexdigest()

mongo_docs = collection.find(
    {},
    {
        "_id": 1,
        "measurements.pm25": 1,
        "measurements.pm10": 1,
        "timestamp": 1
    }
).sort("_id", 1).limit(1000)

mongo_hash_string = ""

for doc in mongo_docs:
    mongo_hash_string += f"{doc['_id']}-{doc['measurements']['pm25']}-{doc['measurements']['pm10']}-{doc['timestamp']};"

mongo_hash = hashlib.md5(mongo_hash_string.encode()).hexdigest()

print("5. Hash Validation on First 1000 Records")
print("SQL Hash:", sql_hash)
print("Mongo Hash:", mongo_hash)

if sql_hash == mongo_hash:
    print("PASS: Hash values match\n")
else:
    print("FAIL: Hash values do not match\n")

print("========== VALIDATION COMPLETED ==========")

sql_conn.close()
mongo_client.close()