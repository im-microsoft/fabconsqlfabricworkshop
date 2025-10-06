-- =============================================
-- View: vw_CustomerOrderSummary  
-- Description: Customer order summary view for reporting
-- Author: Workshop Team
-- Created: 2024
-- =============================================

USE FabricWorkshopDB;
GO

CREATE OR ALTER VIEW dbo.vw_CustomerOrderSummary
AS
SELECT 
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    c.Email,
    c.City,
    c.Country,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    COUNT(oi.OrderItemID) AS TotalItems,
    SUM(o.TotalAmount) AS TotalSpent,
    AVG(o.TotalAmount) AS AverageOrderValue,
    MIN(o.OrderDate) AS FirstOrderDate,
    MAX(o.OrderDate) AS LastOrderDate,
    DATEDIFF(DAY, MIN(o.OrderDate), MAX(o.OrderDate)) AS CustomerLifespanDays,
    CASE 
        WHEN COUNT(DISTINCT o.OrderID) >= 5 THEN 'VIP'
        WHEN COUNT(DISTINCT o.OrderID) >= 2 THEN 'Regular'
        ELSE 'New'
    END AS CustomerSegment,
    CASE
        WHEN MAX(o.OrderDate) >= DATEADD(MONTH, -3, GETDATE()) THEN 'Active'
        WHEN MAX(o.OrderDate) >= DATEADD(MONTH, -6, GETDATE()) THEN 'Dormant'
        ELSE 'Inactive'
    END AS CustomerStatus
FROM dbo.Customers c
LEFT JOIN dbo.Orders o ON c.CustomerID = o.CustomerID
LEFT JOIN dbo.OrderItems oi ON o.OrderID = oi.OrderID
GROUP BY 
    c.CustomerID,
    c.FirstName,
    c.LastName,
    c.Email,
    c.City,
    c.Country;
GO

-- Example queries:
-- SELECT * FROM dbo.vw_CustomerOrderSummary ORDER BY TotalSpent DESC;
-- SELECT * FROM dbo.vw_CustomerOrderSummary WHERE CustomerSegment = 'VIP';