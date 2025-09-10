
CREATE VIEW [SalesLT].[MostSoldProduct] AS 
SELECT TOP 1 p.Name, SUM(od.OrderQty) AS TotalSold 
FROM [SalesLT].[SalesOrderDetail] od 
JOIN [SalesLT].[Product] p ON od.ProductID = p.ProductID 
GROUP BY p.Name 
ORDER BY TotalSold DESC;

GO

