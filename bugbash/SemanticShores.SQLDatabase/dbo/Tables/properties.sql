CREATE TABLE [dbo].[properties] (
    [property_id]         INT            NOT NULL,
    [street_address]      NVARCHAR (200) NOT NULL,
    [neighborhood]        NVARCHAR (100) NOT NULL,
    [city]                NVARCHAR (100) NOT NULL,
    [state_code]          CHAR (2)       NOT NULL,
    [zip_code]            CHAR (5)       NOT NULL,
    [property_type]       NVARCHAR (50)  NOT NULL,
    [bedrooms]            TINYINT        NOT NULL,
    [bathrooms]           DECIMAL (3, 1) NOT NULL,
    [square_feet]         INT            NOT NULL,
    [lot_size_sqft]       INT            NULL,
    [year_built]          SMALLINT       NOT NULL,
    [list_price]          INT            NOT NULL,
    [listing_date]        DATE           NOT NULL,
    [agent_id]            INT            NOT NULL,
    [listing_description] NVARCHAR (MAX) NOT NULL,
    [description_vector]  VECTOR(1536)   NULL,
    [image_filename]      NVARCHAR (255) NULL,
    CONSTRAINT [PK_properties] PRIMARY KEY CLUSTERED ([property_id] ASC)
);


GO

