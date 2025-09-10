-- =============================================
-- Stored Procedure: sp_GetCustomerOrders
-- Description: Get all orders for a specific customer
-- Parameters: @CustomerID - The customer ID to retrieve orders for
-- Author: Workshop Team
-- Created: 2024
-- =============================================

USE FabricWorkshopDB;
GO

CREATE OR ALTER PROCEDURE dbo.sp_GetCustomerOrders
    @CustomerID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validate input parameter
    IF @CustomerID IS NULL OR @CustomerID <= 0
    BEGIN
        RAISERROR('Invalid CustomerID provided', 16, 1);
        RETURN;
    END
    
    -- Check if customer exists
    IF NOT EXISTS (SELECT 1 FROM dbo.Customers WHERE CustomerID = @CustomerID)
    BEGIN
        RAISERROR('Customer not found', 16, 1);
        RETURN;
    END
    
    -- Return customer orders with details
    SELECT 
        c.CustomerID,
        c.FirstName + ' ' + c.LastName AS CustomerName,
        c.Email,
        o.OrderID,
        o.OrderDate,
        o.TotalAmount,
        o.Status,
        oi.OrderItemID,
        p.ProductName,
        oi.Quantity,
        oi.UnitPrice,
        oi.LineTotal
    FROM dbo.Customers c
    INNER JOIN dbo.Orders o ON c.CustomerID = o.CustomerID
    INNER JOIN dbo.OrderItems oi ON o.OrderID = oi.OrderID
    INNER JOIN dbo.Products p ON oi.ProductID = p.ProductID
    WHERE c.CustomerID = @CustomerID
    ORDER BY o.OrderDate DESC, oi.OrderItemID;
    
    -- Return summary information
    SELECT 
        @CustomerID AS CustomerID,
        COUNT(DISTINCT o.OrderID) AS TotalOrders,
        COUNT(oi.OrderItemID) AS TotalItems,
        SUM(o.TotalAmount) AS TotalSpent,
        MAX(o.OrderDate) AS LastOrderDate
    FROM dbo.Orders o
    INNER JOIN dbo.OrderItems oi ON o.OrderID = oi.OrderID
    WHERE o.CustomerID = @CustomerID;
END
GO

-- Example usage:
-- EXEC dbo.sp_GetCustomerOrders @CustomerID = 1;