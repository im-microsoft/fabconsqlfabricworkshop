CREATE TABLE [dbo].[SalesFact_CCI] (
    [SalesKey]       BIGINT          NOT NULL,
    [ProductID]      INT             NOT NULL,
    [CustomerID]     INT             NOT NULL,
    [SaleDate]       DATE            NOT NULL,
    [StoreID]        INT             NOT NULL,
    [Quantity]       INT             NOT NULL,
    [UnitPrice]      DECIMAL (10, 2) NOT NULL,
    [DiscountAmount] DECIMAL (10, 2) NOT NULL,
    [TaxAmount]      DECIMAL (10, 2) NOT NULL
);


GO

CREATE CLUSTERED COLUMNSTORE INDEX [CCI_SalesData]
    ON [dbo].[SalesFact_CCI];


GO

