/*
==============================================================================
Create Database and Schema
==============================================================================
Script Purpose:
     This script creates a new database named 'Datawarehouse' after checking if it already exists.
	 If the database exist, it is dropped and recreated. additionally, the script sets up three schemas
	 within the database: 'bronze', 'silver', and 'gold'.

Warning:
     Running this script will drop the entire ' Datawarehouse' database if it exists.
	 all data in the database will permanetly deleted. Proceed with caution and ensure you
	 have proper backups before running this script.
*/

USE master;
GO

--Drop and recreate the 'Datawarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Datawarehouse')
BEGIN
  ALTER DATABASE Datawarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE Datawarehouse;
END;
GO


-- Create the 'Datawarehouse' database
CREATE DATABASE Datawarehouse;
GO

USE Datawarehouse;
GO


-- Create Schema
CREATE SCHEMA bronze;
GO


CREATE SCHEMA silver;
GO


CREATE SCHEMA gold;
GO



