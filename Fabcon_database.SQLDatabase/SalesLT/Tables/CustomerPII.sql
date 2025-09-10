CREATE TABLE [SalesLT].[CustomerPII] (
    [CustomerID]   INT                                                            IDENTITY (1, 1) NOT NULL,
    [FullName]     NVARCHAR (50)                                                  NULL,
    [EmailAddress] NVARCHAR (50) MASKED WITH (FUNCTION = 'email()')               NULL,
    [Phone]        NVARCHAR (25) MASKED WITH (FUNCTION = 'partial(0, "XXXX", 4)') NULL
);


GO

