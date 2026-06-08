USE AirQualityDB;
GO

SELECT COUNT(*) AS RawRows
FROM dbo.combined_sensor_data;

SELECT COUNT(*) AS Locations
FROM dbo.Locations;

SELECT COUNT(*) AS Sensors
FROM dbo.Sensors;

SELECT COUNT(*) AS Pollutants
FROM dbo.Pollutants;

SELECT COUNT(*) AS SensorReadings
FROM dbo.SensorReadings;


SELECT
    SensorID,
    PollutantID,
    ReadingTime,
    COUNT(*) AS DuplicateCount
FROM dbo.SensorReadings
GROUP BY
    SensorID,
    PollutantID,
    ReadingTime
HAVING COUNT(*) > 1;
GO
