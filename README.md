\# Air Quality Data Migration Project



\## Students



\* Era Sela (130857)

\* Diellza Jusufi (130832)



\## Course



NoSQL Databases



\## Professor



Benjamin Besimi



\## University



South East European University (SEEU)



\## Project Overview



This project demonstrates the migration of air quality monitoring data from Microsoft SQL Server to MongoDB. The project includes relational database design, NoSQL data modeling, data transformation, validation procedures, and Power BI visualizations.



\## Technologies Used



\* Microsoft SQL Server

\* MongoDB

\* MongoDB Compass

\* Python

\* pyodbc

\* pymongo

\* pandas

\* Power BI

\* GitHub



\## Relational Database



Tables:



\* Locations

\* Sensors

\* SensorReadings

\* Pollutants



The SensorReadings table contains 181,398 records.



\## NoSQL Database



MongoDB was selected as the target database because of its document-oriented structure, support for embedded documents, and strong aggregation capabilities.



\## Derived Fields



The migration process generates the following derived fields:



\* pollutionScore

\* aqiCategory

\* severityLevel



\## Running the Project



\### 1. Create and Populate SQL Server Database



Run the SQL scripts to create the relational database schema and populate the tables.



\### 2. Run Migration



Execute:



python 04\_MongoMigration.py



This script migrates data from SQL Server to MongoDB.



\### 3. Run Validation



Execute:



python 05\_Validation.py



This script compares SQL Server and MongoDB data and verifies migration accuracy.



\### 4. Export Data



Execute:



python 06\_ExportMongoToCSV.py



This exports MongoDB data for Power BI analysis.



\### 5. Open Power BI Dashboard



Open the Power BI dashboard file (.pbix) to explore the visualizations.



\## Validation Checks



The following validation checks are performed:



\* Record Count Validation

\* Average PM2.5 Validation

\* Average Temperature Validation

\* Average Humidity Validation

\* Hash Validation



\## Repository Contents



\* SQL scripts

\* Python migration scripts

\* Validation scripts

\* Export scripts

\* Power BI dashboard

\* Project report

