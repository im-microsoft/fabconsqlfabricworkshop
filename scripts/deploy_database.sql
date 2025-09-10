-- =============================================
-- Database Deployment Script
-- Description: Complete deployment script for FabricWorkshop database
-- Usage: Execute this script to set up the complete database
-- Author: Workshop Team
-- Created: 2024
-- =============================================

PRINT 'Starting FabricWorkshop Database Deployment...';
PRINT '================================================';

-- Step 1: Create Database
PRINT 'Step 1: Creating database...';
:r "$(SQLCMDPATH)\..\schemas\01_create_database.sql"

-- Step 2: Create Tables  
PRINT 'Step 2: Creating tables...';
:r "$(SQLCMDPATH)\..\schemas\02_create_tables.sql"

-- Step 3: Apply Migrations
PRINT 'Step 3: Applying migrations...';
:r "$(SQLCMDPATH)\..\migrations\V001_initial_schema.sql"

-- Step 4: Create Stored Procedures
PRINT 'Step 4: Creating stored procedures...';
:r "$(SQLCMDPATH)\..\procedures\sp_GetCustomerOrders.sql"

-- Step 5: Create Views
PRINT 'Step 5: Creating views...';
:r "$(SQLCMDPATH)\..\views\vw_CustomerOrderSummary.sql"

-- Step 6: Insert Sample Data
PRINT 'Step 6: Inserting sample data...';
:r "$(SQLCMDPATH)\..\data\sample_data.sql"

PRINT '================================================';
PRINT 'FabricWorkshop Database Deployment Complete!';
PRINT 'Database: FabricWorkshopDB';
PRINT 'Status: Ready for use';

-- Verify deployment
USE FabricWorkshopDB;
GO

SELECT 'Deployment Verification' AS Status;
SELECT 
    'Categories' AS TableName,
    COUNT(*) AS RecordCount
FROM dbo.Categories
UNION ALL
SELECT 'Products', COUNT(*) FROM dbo.Products  
UNION ALL
SELECT 'Customers', COUNT(*) FROM dbo.Customers
UNION ALL
SELECT 'Orders', COUNT(*) FROM dbo.Orders
UNION ALL
SELECT 'OrderItems', COUNT(*) FROM dbo.OrderItems;

PRINT 'Verification complete. Check results above.';