CREATE TABLE [dbo].[employees] (
    [employee_ID] INT           IDENTITY (1, 1) NOT NULL,
    [FirstName]   VARCHAR (100) NULL,
    [LastName]    VARCHAR (100) NULL,
    [JobTitle]    NVARCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([employee_ID] ASC)
);


GO

