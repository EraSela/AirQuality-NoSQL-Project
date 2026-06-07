import pyodbc
from pymongo import MongoClient
import logging

# -----------------------------
# Logging Configuration
# -----------------------------

logging.basicConfig(
    filename="migration.log",
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)

# -----------------------------
# AQI Category
# -----------------------------

def get_aqi_category(pm25):
    if pm25 <= 12:
        return "Good"
    elif pm25 <= 35:
        return "Moderate"
    elif pm25 <= 55:
        return "Unhealthy for Sensitive Groups"
    elif pm25 <= 150:
        return "Unhealthy"
    else:
        return "Very Unhealthy"

# -----------------------------
# Severity Level
# -----------------------------

def get_severity(score):
    if score < 20:
        return "Low"
    elif score < 50:
        return "Medium"
    elif score < 100:
        return "High"
    else:
        return "Critical"

try:
    # -----------------------------
    # SQL Server Connection
    # -----------------------------

    conn = pyodbc.connect(
        "DRIVER={ODBC Driver 17 for SQL Server};"
        "SERVER=localhost;"
        "DATABASE=AirQualityDB;"
        "Trusted_Connection=yes;"
    )

    cursor = conn.cursor()

    # -----------------------------
    # MongoDB Connection
    # -----------------------------

    client = MongoClient("mongodb://localhost:27017/")
    db = client["AirQualityMongo"]
    collection = db["sensor_readings"]

    logging.info("Connected successfully to SQL Server and MongoDB.")

    # -----------------------------
    # Query SQL Server
    # -----------------------------

    query = """
    SELECT
        r.ReadingID,
        r.ReadingTime,
        r.Temperature,
        r.Humidity,
        r.PM1,
        r.PM25,
        r.PM10,
        s.SensorName,
        l.LocationName,
        l.Latitude,
        l.Longitude
    FROM SensorReadings r
    INNER JOIN Sensors s
        ON r.SensorID = s.SensorID
    INNER JOIN Locations l
        ON s.LocationID = l.LocationID
    """

    cursor.execute(query)
    rows = cursor.fetchall()

    count = 0
    error_count = 0

    # -----------------------------
    # Migration
    # -----------------------------

    for row in rows:
        try:
            # Error scenario 1: invalid pollution values
            if row.PM1 < 0 or row.PM25 < 0 or row.PM10 < 0:
                logging.error(f"Invalid negative pollution value in ReadingID {row.ReadingID}")
                error_count += 1
                continue

            # Error scenario 2: missing required values
            if row.ReadingTime is None or row.SensorName is None or row.LocationName is None:
                logging.error(f"Missing required value in ReadingID {row.ReadingID}")
                error_count += 1
                continue

            pollution_score = (
                row.PM1 * 0.2 +
                row.PM25 * 0.4 +
                row.PM10 * 0.4
            )

            document = {
                "_id": row.ReadingID,

                "timestamp": row.ReadingTime,

                "sensor": {
                    "sensorName": row.SensorName
                },

                "location": {
                    "name": row.LocationName,
                    "latitude": row.Latitude,
                    "longitude": row.Longitude
                },

                "measurements": {
                    "temperature": row.Temperature,
                    "humidity": row.Humidity,
                    "pm1": row.PM1,
                    "pm25": row.PM25,
                    "pm10": row.PM10
                },

                "pollutionScore": round(pollution_score, 2),
                "aqiCategory": get_aqi_category(row.PM25),
                "severityLevel": get_severity(pollution_score)
            }

            collection.replace_one(
                {"_id": row.ReadingID},
                document,
                upsert=True
            )

            count += 1

        except Exception as row_error:
            logging.error(f"Error migrating ReadingID {row.ReadingID}: {row_error}")
            error_count += 1

    print(f"{count} records migrated successfully.")
    print(f"{error_count} records failed. Check migration.log for details.")

    logging.info(f"Migration completed. Success: {count}, Failed: {error_count}")

except pyodbc.Error as sql_error:
    print("SQL Server connection/query error. Check migration.log.")
    logging.error(f"SQL Server error: {sql_error}")

except Exception as general_error:
    print("Migration failed. Check migration.log.")
    logging.error(f"General migration error: {general_error}")

finally:
    try:
        cursor.close()
        conn.close()
        client.close()
    except:
        pass