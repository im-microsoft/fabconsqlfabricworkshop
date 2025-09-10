CREATE TABLE [dbo].[Employee_Assigned_Products] (
    [Emp_Assigned_Pdct_ID] INT IDENTITY (1, 1) NOT NULL,
    [employee_ID]          INT NOT NULL,
    [ProductID]            INT NOT NULL,
    PRIMARY KEY CLUSTERED ([Emp_Assigned_Pdct_ID] ASC)
);


GO

