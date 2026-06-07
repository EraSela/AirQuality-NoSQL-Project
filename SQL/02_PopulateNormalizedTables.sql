USE AirQualityDB;
GO

--------------------------------------------------
-- Locations
-- Insert only locations that do not already exist
--------------------------------------------------

INSERT INTO Locations
(
    LocationName,
    Latitude,
    Longitude
)
SELECT DISTINCT
    c.location,
    c.latitude,
    c.longitude
FROM dbo.combined_sensor_data c
LEFT JOIN Locations l
    ON c.location = l.LocationName
WHERE l.LocationID IS NULL;
GO

--------------------------------------------------
-- Sensors
-- Insert only sensors that do not already exist
--------------------------------------------------

INSERT INTO Sensors
(
    SensorName,
    LocationID
)
SELECT DISTINCT
    c.sensor_id,
    l.LocationID
FROM dbo.combined_sensor_data c
INNER JOIN Locations l
    ON c.location = l.LocationName
LEFT JOIN Sensors s
    ON c.sensor_id = s.SensorName
WHERE s.SensorID IS NULL;
GO

--------------------------------------------------
-- Pollutants
-- Insert only pollutants that do not already exist
--------------------------------------------------

INSERT INTO Pollutants
(
    PollutantName,
    Unit
)
SELECT v.PollutantName, v.Unit
FROM
(
    VALUES
    ('PM1', 'µg/m³'),
    ('PM2.5', 'µg/m³'),
    ('PM10', 'µg/m³'),
    ('Temperature', '°C'),
    ('Humidity', '%')
) v(PollutantName, Unit)
LEFT JOIN Pollutants p
    ON p.PollutantName = v.PollutantName
WHERE p.PollutantID IS NULL;
GO

--------------------------------------------------
-- Sensor Readings
-- Insert only readings that do not already exist
--------------------------------------------------

INSERT INTO SensorReadings
(
    SensorID,
    ReadingTime,
    Temperature,
    Humidity,
    PM1,
    PM25,
    PM10
)
SELECT
    s.SensorID,
    c.[time],
    c.OPC_T,
    c.OPC_RH,
    c.pm1,
    c.pm2_5,
    c.pm10
FROM dbo.combined_sensor_data c
INNER JOIN Sensors s
    ON c.sensor_id = s.SensorName
LEFT JOIN SensorReadings r
    ON r.SensorID = s.SensorID
    AND r.ReadingTime = c.[time]
WHERE r.ReadingID IS NULL;