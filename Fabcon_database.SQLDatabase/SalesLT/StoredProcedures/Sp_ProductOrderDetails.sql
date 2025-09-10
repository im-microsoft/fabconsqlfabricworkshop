CREATE    Proc [SalesLT].[Sp_ProductOrderDetails] AS    
BEGIN
SELECT P.Name ProductName
      ,SO.OrderQty
      ,SO.ProductID
      ,SO.UnitPrice
      ,SO.UnitPriceDiscount
  FROM [SalesLT].[SalesOrderDetail] as SO
  join [SalesLT].[Product] as P on SO.ProductID=P.ProductID  
END

GO

