CREATE TABLE [dbo].[product_reviews] (
    [ReviewID]       INT            IDENTITY (1, 1) NOT NULL,
    [ProductID]      INT            NOT NULL,
    [ReviewText]     NVARCHAR (MAX) NULL,
    [SentimentLabel] VARCHAR (10)   NULL,
    [CreatedAt]      DATETIME       DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ReviewID] ASC)
);


GO

