-- =============================================
-- Database Cleanup Script
-- Description: Clean up and reset the FabricWorkshop database
-- Usage: Execute this script to remove all data or drop the database
-- Author: Workshop Team
-- Created: 2024
-- WARNING: This script will delete data. Use with caution!
-- =============================================

USE master;
GO

PRINT 'FabricWorkshop Database Cleanup Script';
PRINT '=====================================';
PRINT 'WARNING: This will delete database and all data!';

-- Uncomment one of the following options:

-- OPTION 1: Clear all data but keep structure
/*
USE FabricWorkshopDB;
GO

PRINT 'Clearing all data...';

-- Disable foreign key constraints
EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"

-- Delete data from all tables
DELETE FROM dbo.OrderItems;
DELETE FROM dbo.Orders;
DELETE FROM dbo.Products;
DELETE FROM dbo.Categories;
DELETE FROM dbo.Customers;
DELETE FROM dbo.SchemaVersions;

-- Re-enable foreign key constraints
EXEC sp_msforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"

-- Reset identity seeds
DBCC CHECKIDENT ('dbo.Categories', RESEED, 0);
DBCC CHECKIDENT ('dbo.Products', RESEED, 0);
DBCC CHECKIDENT ('dbo.Customers', RESEED, 0);
DBCC CHECKIDENT ('dbo.Orders', RESEED, 0);
DBCC CHECKIDENT ('dbo.OrderItems', RESEED, 0);
DBCC CHECKIDENT ('dbo.SchemaVersions', RESEED, 0);

PRINT 'All data cleared successfully. Database structure preserved.';
*/

-- OPTION 2: Drop entire database (DANGEROUS!)
/*
USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'FabricWorkshopDB')
BEGIN
    -- Kill all connections to the database
    ALTER DATABASE FabricWorkshopDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    
    -- Drop the database
    DROP DATABASE FabricWorkshopDB;
    
    PRINT 'FabricWorkshopDB database dropped successfully.';
END
ELSE
BEGIN
    PRINT 'FabricWorkshopDB database does not exist.';
END
*/

-- OPTION 3: Just show what would be deleted (SAFE)
USE FabricWorkshopDB;
GO

PRINT 'Current database contents:';
SELECT 'Categories' AS TableName, COUNT(*) AS RecordCount FROM dbo.Categories
UNION ALL
SELECT 'Products', COUNT(*) FROM dbo.Products
UNION ALL  
SELECT 'Customers', COUNT(*) FROM dbo.Customers
UNION ALL
SELECT 'Orders', COUNT(*) FROM dbo.Orders
UNION ALL
SELECT 'OrderItems', COUNT(*) FROM dbo.OrderItems;

PRINT '';
PRINT 'To actually clean up data:';
PRINT '1. Uncomment OPTION 1 to clear data but keep structure';
PRINT '2. Uncomment OPTION 2 to drop the entire database';
PRINT 'Current script is in SAFE mode - no changes made.';