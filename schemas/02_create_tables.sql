-- =============================================
-- Create Tables: Core schema tables
-- Description: Main tables for the Fabric Workshop database
-- Author: Workshop Team  
-- Created: 2024
-- =============================================

USE FabricWorkshopDB;
GO

-- Create Customers table
CREATE TABLE dbo.Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Phone NVARCHAR(20),
    Address NVARCHAR(255),
    City NVARCHAR(50),
    Country NVARCHAR(50),
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    ModifiedDate DATETIME2 DEFAULT GETDATE()
);

-- Create Products table
CREATE TABLE dbo.Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
    CategoryID INT,
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    ModifiedDate DATETIME2 DEFAULT GETDATE()
);

-- Create Categories table  
CREATE TABLE dbo.Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255),
    CreatedDate DATETIME2 DEFAULT GETDATE()
);

-- Create Orders table
CREATE TABLE dbo.Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATETIME2 DEFAULT GETDATE(),
    TotalAmount DECIMAL(12,2) NOT NULL DEFAULT 0,
    Status NVARCHAR(20) DEFAULT 'Pending' CHECK (Status IN ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled')),
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    ModifiedDate DATETIME2 DEFAULT GETDATE()
);

-- Create OrderItems table
CREATE TABLE dbo.OrderItems (
    OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0),
    LineTotal AS (Quantity * UnitPrice) PERSISTED
);

-- Add foreign key constraints
ALTER TABLE dbo.Products
ADD CONSTRAINT FK_Products_Categories 
FOREIGN KEY (CategoryID) REFERENCES dbo.Categories(CategoryID);

ALTER TABLE dbo.Orders
ADD CONSTRAINT FK_Orders_Customers 
FOREIGN KEY (CustomerID) REFERENCES dbo.Customers(CustomerID);

ALTER TABLE dbo.OrderItems
ADD CONSTRAINT FK_OrderItems_Orders 
FOREIGN KEY (OrderID) REFERENCES dbo.Orders(OrderID);

ALTER TABLE dbo.OrderItems
ADD CONSTRAINT FK_OrderItems_Products 
FOREIGN KEY (ProductID) REFERENCES dbo.Products(ProductID);

-- Create indexes for better performance
CREATE NONCLUSTERED INDEX IX_Customers_Email ON dbo.Customers(Email);
CREATE NONCLUSTERED INDEX IX_Products_CategoryID ON dbo.Products(CategoryID);
CREATE NONCLUSTERED INDEX IX_Orders_CustomerID ON dbo.Orders(CustomerID);
CREATE NONCLUSTERED INDEX IX_Orders_OrderDate ON dbo.Orders(OrderDate);
CREATE NONCLUSTERED INDEX IX_OrderItems_OrderID ON dbo.OrderItems(OrderID);
CREATE NONCLUSTERED INDEX IX_OrderItems_ProductID ON dbo.OrderItems(ProductID);

PRINT 'Core tables created successfully';