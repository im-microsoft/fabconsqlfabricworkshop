CREATE TABLE [dbo].[product_review_feedback] (
    [ProductID]         INT           NOT NULL,
    [ReviewID]          INT           NOT NULL,
    [employee_ID]       INT           NOT NULL,
    [employee_comments] VARCHAR (MAX) NULL,
    [resolution]        VARCHAR (MAX) NULL,
    [created_date]      DATETIME      DEFAULT (getdate()) NULL,
    [updated_date]      DATETIME      NULL
);


GO

