USE AirQualityDB;
GO

-- Average pollution values
SELECT
    p.PollutantName,
    AVG(r.Value) AS AverageValue,
    p.Unit
FROM dbo.SensorReadings r
JOIN dbo.Pollutants p
    ON r.PollutantID = p.PollutantID
GROUP BY
    p.PollutantName,
    p.Unit;

-- Readings per sensor
SELECT
    s.SensorName,
    COUNT(*) AS TotalReadings
FROM dbo.SensorReadings r
JOIN dbo.Sensors s
    ON r.SensorID = s.SensorID
GROUP BY s.SensorName;

-- Average PM2.5 by location
SELECT
    l.LocationName,
    AVG(r.Value) AS AvgPM25
FROM dbo.SensorReadings r
JOIN dbo.Sensors s
    ON r.SensorID = s.SensorID
JOIN dbo.Locations l
    ON s.LocationID = l.LocationID
JOIN dbo.Pollutants p
    ON r.PollutantID = p.PollutantID
WHERE p.PollutantName = 'PM2.5'
GROUP BY l.LocationName;

SELECT @@SERVERNAME AS ServerName;