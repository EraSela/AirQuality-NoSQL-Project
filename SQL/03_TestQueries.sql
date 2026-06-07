USE AirQualityDB;
GO

SELECT COUNT(*) AS RawRows
FROM dbo.combined_sensor_data;

SELECT COUNT(*) AS Locations
FROM Locations;

SELECT COUNT(*) AS Sensors
FROM Sensors;

SELECT COUNT(*) AS Pollutants
FROM Pollutants;

SELECT COUNT(*) AS SensorReadings
FROM SensorReadings;

SELECT
    SensorID,
    ReadingTime,
    COUNT(*) AS DuplicateCount
FROM SensorReadings
GROUP BY
    SensorID,
    ReadingTime
HAVING COUNT(*) > 1;