CREATE PROCEDURE find_products_wrapper
@name NVARCHAR(100)
AS
BEGIN
    SELECT ProductID, Name, ListPrice
    FROM SalesLT.Product
    WHERE Name LIKE '%' + @name + '%'
END

GO

