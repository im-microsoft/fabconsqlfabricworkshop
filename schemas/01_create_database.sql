-- =============================================
-- Create Database: FabricWorkshopDB
-- Description: Main database for the Fabric Workshop
-- Author: Workshop Team
-- Created: 2024
-- =============================================

USE master;
GO

-- Check if database exists and drop if it does (for development)
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'FabricWorkshopDB')
BEGIN
    DROP DATABASE FabricWorkshopDB;
END
GO

-- Create the database
CREATE DATABASE FabricWorkshopDB
ON 
( NAME = 'FabricWorkshopDB_Data',
  FILENAME = 'C:\Data\FabricWorkshopDB_Data.mdf',
  SIZE = 100MB,
  MAXSIZE = 1GB,
  FILEGROWTH = 10MB )
LOG ON 
( NAME = 'FabricWorkshopDB_Log',
  FILENAME = 'C:\Data\FabricWorkshopDB_Log.ldf',
  SIZE = 10MB,
  MAXSIZE = 100MB,
  FILEGROWTH = 1MB );
GO

-- Use the new database
USE FabricWorkshopDB;
GO

PRINT 'Database FabricWorkshopDB created successfully';