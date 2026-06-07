USE AirQualityDB;
GO

-- Average pollution values
SELECT
    AVG(PM1) AS AvgPM1,
    AVG(PM25) AS AvgPM25,
    AVG(PM10) AS AvgPM10
FROM SensorReadings;

-- Readings per sensor
SELECT
    s.SensorName,
    COUNT(*) AS TotalReadings
FROM SensorReadings r
JOIN Sensors s
    ON r.SensorID = s.SensorID
GROUP BY s.SensorName;

-- Average PM2.5 by location
SELECT
    l.LocationName,
    AVG(r.PM25) AS AvgPM25
FROM SensorReadings r
JOIN Sensors s
    ON r.SensorID = s.SensorID
JOIN Locations l
    ON s.LocationID = l.LocationID
GROUP BY l.LocationName;

SELECT @@SERVERNAME AS ServerName;