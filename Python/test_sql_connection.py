import pyodbc

conn = pyodbc.connect(
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=localhost;"
    "DATABASE=AirQualityDB;"
    "Trusted_Connection=yes;"
)

cursor = conn.cursor()
cursor.execute("SELECT COUNT(*) FROM SensorReadings")

print("Rows:", cursor.fetchone()[0])

conn.close()