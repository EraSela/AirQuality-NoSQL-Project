IF DB_ID('AirQualityDB') IS NULL
BEGIN
    CREATE DATABASE AirQualityDB;
END
GO

USE AirQualityDB;
GO

IF OBJECT_ID('dbo.Locations', 'U') IS NULL
BEGIN
    CREATE TABLE Locations
    (
        LocationID INT IDENTITY(1,1) PRIMARY KEY,
        LocationName NVARCHAR(100) NOT NULL UNIQUE,
        Latitude FLOAT NOT NULL,
        Longitude FLOAT NOT NULL
    );
END
GO

IF OBJECT_ID('dbo.Sensors', 'U') IS NULL
BEGIN
    CREATE TABLE Sensors
    (
        SensorID INT IDENTITY(1,1) PRIMARY KEY,
        SensorName NVARCHAR(50) NOT NULL UNIQUE,
        LocationID INT NOT NULL,
        FOREIGN KEY (LocationID) REFERENCES Locations(LocationID)
    );
END
GO

IF OBJECT_ID('dbo.Pollutants', 'U') IS NULL
BEGIN
    CREATE TABLE Pollutants
    (
        PollutantID INT IDENTITY(1,1) PRIMARY KEY,
        PollutantName NVARCHAR(50) NOT NULL UNIQUE,
        Unit NVARCHAR(20) NOT NULL
    );
END
GO

IF OBJECT_ID('dbo.SensorReadings', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.SensorReadings
    (
        ReadingID INT IDENTITY(1,1) PRIMARY KEY,
        SensorID INT NOT NULL,
        PollutantID INT NOT NULL,
        ReadingTime DATETIME2 NOT NULL,
        Temperature FLOAT NOT NULL,
        Humidity FLOAT NOT NULL,
        Value FLOAT NOT NULL,

        FOREIGN KEY (SensorID)
            REFERENCES dbo.Sensors(SensorID),

        FOREIGN KEY (PollutantID)
            REFERENCES dbo.Pollutants(PollutantID),

        CHECK (Humidity BETWEEN 0 AND 100),
        CHECK (Value >= 0)
    );
END
GO

