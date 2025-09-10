-- =============================================
-- Sample Data: Core tables seed data
-- Description: Sample data for the Fabric Workshop database
-- Author: Workshop Team
-- Created: 2024
-- =============================================

USE FabricWorkshopDB;
GO

-- Insert Categories
INSERT INTO dbo.Categories (CategoryName, Description) VALUES
('Electronics', 'Electronic devices and accessories'),
('Clothing', 'Apparel and fashion items'),
('Books', 'Physical and digital books'),
('Home & Garden', 'Home improvement and gardening supplies'),
('Sports', 'Sports equipment and accessories');

-- Insert Products
INSERT INTO dbo.Products (ProductName, Description, Price, CategoryID) VALUES
('Laptop Computer', 'High-performance laptop for business use', 999.99, 1),
('Wireless Mouse', 'Ergonomic wireless mouse', 29.99, 1),
('Bluetooth Headphones', 'Noise-cancelling wireless headphones', 149.99, 1),
('Cotton T-Shirt', 'Comfortable cotton t-shirt', 19.99, 2),
('Jeans', 'Classic blue denim jeans', 59.99, 2),
('Programming Book', 'Learn SQL Server development', 49.99, 3),
('Database Design Guide', 'Complete guide to database design', 39.99, 3),
('Garden Hose', '50-foot flexible garden hose', 24.99, 4),
('Flower Seeds', 'Mixed flower seed packet', 9.99, 4),
('Tennis Racket', 'Professional tennis racket', 129.99, 5),
('Running Shoes', 'Lightweight running shoes', 89.99, 5);

-- Insert Customers
INSERT INTO dbo.Customers (FirstName, LastName, Email, Phone, Address, City, Country) VALUES
('John', 'Doe', 'john.doe@email.com', '+1-555-0101', '123 Main St', 'New York', 'USA'),
('Jane', 'Smith', 'jane.smith@email.com', '+1-555-0102', '456 Oak Ave', 'Los Angeles', 'USA'),
('Bob', 'Johnson', 'bob.johnson@email.com', '+1-555-0103', '789 Pine Rd', 'Chicago', 'USA'),
('Alice', 'Wilson', 'alice.wilson@email.com', '+1-555-0104', '321 Elm St', 'Houston', 'USA'),
('Charlie', 'Brown', 'charlie.brown@email.com', '+1-555-0105', '654 Maple Dr', 'Phoenix', 'USA'),
('Diana', 'Davis', 'diana.davis@email.com', '+1-555-0106', '987 Cedar Ln', 'Philadelphia', 'USA');

-- Insert Orders
INSERT INTO dbo.Orders (CustomerID, TotalAmount, Status) VALUES
(1, 1029.98, 'Delivered'),
(2, 179.98, 'Shipped'),
(3, 49.99, 'Processing'),
(4, 149.97, 'Pending'),
(5, 219.98, 'Delivered'),
(6, 39.99, 'Processing');

-- Insert Order Items
INSERT INTO dbo.OrderItems (OrderID, ProductID, Quantity, UnitPrice) VALUES
-- Order 1 (John Doe)
(1, 1, 1, 999.99),  -- Laptop
(1, 2, 1, 29.99),   -- Mouse

-- Order 2 (Jane Smith) 
(2, 3, 1, 149.99),  -- Headphones
(2, 2, 1, 29.99),   -- Mouse

-- Order 3 (Bob Johnson)
(3, 6, 1, 49.99),   -- Programming Book

-- Order 4 (Alice Wilson)
(4, 4, 3, 19.99),   -- T-Shirts
(4, 8, 3, 24.99),   -- Garden Hose
(4, 9, 5, 9.99),    -- Flower Seeds

-- Order 5 (Charlie Brown)
(5, 10, 1, 129.99), -- Tennis Racket
(5, 11, 1, 89.99),  -- Running Shoes

-- Order 6 (Diana Davis)
(6, 7, 1, 39.99);   -- Database Design Guide

PRINT 'Sample data inserted successfully';

-- Display summary
SELECT 
    (SELECT COUNT(*) FROM dbo.Categories) AS CategoriesCount,
    (SELECT COUNT(*) FROM dbo.Products) AS ProductsCount,
    (SELECT COUNT(*) FROM dbo.Customers) AS CustomersCount,
    (SELECT COUNT(*) FROM dbo.Orders) AS OrdersCount,
    (SELECT COUNT(*) FROM dbo.OrderItems) AS OrderItemsCount;