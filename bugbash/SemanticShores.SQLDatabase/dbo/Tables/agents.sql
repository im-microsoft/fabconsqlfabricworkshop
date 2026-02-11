CREATE TABLE [dbo].[agents] (
    [agent_id]         INT            IDENTITY (1, 1) NOT NULL,
    [agent_name]       NVARCHAR (100) NOT NULL,
    [email]            NVARCHAR (100) NOT NULL,
    [phone]            NVARCHAR (20)  NOT NULL,
    [rating]           DECIMAL (2, 1) NOT NULL,
    [years_experience] INT            NOT NULL,
    PRIMARY KEY CLUSTERED ([agent_id] ASC),
    CHECK ([rating]>=(1.0) AND [rating]<=(5.0)),
    CHECK ([years_experience]>=(0))
);


GO

