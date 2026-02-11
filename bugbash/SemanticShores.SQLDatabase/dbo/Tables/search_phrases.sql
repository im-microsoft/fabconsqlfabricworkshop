CREATE TABLE [dbo].[search_phrases] (
    [search_id]     INT            IDENTITY (1, 1) NOT NULL,
    [search_phrase] NVARCHAR (500) NOT NULL,
    [search_vector] VECTOR(1536)   NULL,
    [category]      NVARCHAR (50)  NULL,
    [created_date]  DATETIME2 (7)  DEFAULT (sysdatetime()) NOT NULL,
    CONSTRAINT [PK_search_phrases] PRIMARY KEY CLUSTERED ([search_id] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_search_phrases_category]
    ON [dbo].[search_phrases]([category] ASC)
    INCLUDE([search_phrase]);


GO

CREATE NONCLUSTERED INDEX [IX_search_phrases_phrase]
    ON [dbo].[search_phrases]([search_phrase] ASC);


GO

