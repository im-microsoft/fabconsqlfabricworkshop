CREATE   VIEW SalesLT.vMostSoldProduct AS
SELECT TOP 1 SD.ProductID, SUM(SD.OrderQty) AS TotalQuantitySold
FROM SalesLT.SalesOrderDetail SD
INNER JOIN SalesLT.Product P ON SD.ProductID = P.ProductID
WHERE P.SellEndDate IS NULL
GROUP BY SD.ProductID
ORDER BY TotalQuantitySold DESC;

GO

