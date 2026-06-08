USE AirQualityDB;
GO

--------------------------------------------------
-- Locations
--------------------------------------------------

INSERT INTO dbo.Locations
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
LEFT JOIN dbo.Locations l
    ON c.location = l.LocationName
WHERE l.LocationID IS NULL;
GO

--------------------------------------------------
-- Sensors
--------------------------------------------------

INSERT INTO dbo.Sensors
(
    SensorName,
    LocationID
)
SELECT DISTINCT
    c.sensor_id,
    l.LocationID
FROM dbo.combined_sensor_data c
INNER JOIN dbo.Locations l
    ON c.location = l.LocationName
LEFT JOIN dbo.Sensors s
    ON c.sensor_id = s.SensorName
WHERE s.SensorID IS NULL;
GO

--------------------------------------------------
-- Pollutants
--------------------------------------------------

INSERT INTO dbo.Pollutants
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
    ('PM10', 'µg/m³')
) v(PollutantName, Unit)
LEFT JOIN dbo.Pollutants p
    ON p.PollutantName = v.PollutantName
WHERE p.PollutantID IS NULL;
GO

--------------------------------------------------
-- Sensor Readings
-- PM1
--------------------------------------------------

INSERT INTO dbo.SensorReadings
(
    SensorID,
    PollutantID,
    ReadingTime,
    Temperature,
    Humidity,
    Value
)
SELECT
    s.SensorID,
    p.PollutantID,
    c.[time],
    c.OPC_T,
    c.OPC_RH,
    c.pm1
FROM dbo.combined_sensor_data c
INNER JOIN dbo.Sensors s
    ON c.sensor_id = s.SensorName
INNER JOIN dbo.Pollutants p
    ON p.PollutantName = 'PM1'
LEFT JOIN dbo.SensorReadings r
    ON r.SensorID = s.SensorID
    AND r.PollutantID = p.PollutantID
    AND r.ReadingTime = c.[time]
WHERE r.ReadingID IS NULL;
GO

--------------------------------------------------
-- Sensor Readings
-- PM2.5
--------------------------------------------------

INSERT INTO dbo.SensorReadings
(
    SensorID,
    PollutantID,
    ReadingTime,
    Temperature,
    Humidity,
    Value
)
SELECT
    s.SensorID,
    p.PollutantID,
    c.[time],
    c.OPC_T,
    c.OPC_RH,
    c.pm2_5
FROM dbo.combined_sensor_data c
INNER JOIN dbo.Sensors s
    ON c.sensor_id = s.SensorName
INNER JOIN dbo.Pollutants p
    ON p.PollutantName = 'PM2.5'
LEFT JOIN dbo.SensorReadings r
    ON r.SensorID = s.SensorID
    AND r.PollutantID = p.PollutantID
    AND r.ReadingTime = c.[time]
WHERE r.ReadingID IS NULL;
GO

--------------------------------------------------
-- Sensor Readings
-- PM10
--------------------------------------------------

INSERT INTO dbo.SensorReadings
(
    SensorID,
    PollutantID,
    ReadingTime,
    Temperature,
    Humidity,
    Value
)
SELECT
    s.SensorID,
    p.PollutantID,
    c.[time],
    c.OPC_T,
    c.OPC_RH,
    c.pm10
FROM dbo.combined_sensor_data c
INNER JOIN dbo.Sensors s
    ON c.sensor_id = s.SensorName
INNER JOIN dbo.Pollutants p
    ON p.PollutantName = 'PM10'
LEFT JOIN dbo.SensorReadings r
    ON r.SensorID = s.SensorID
    AND r.PollutantID = p.PollutantID
    AND r.ReadingTime = c.[time]
WHERE r.ReadingID IS NULL;
GO