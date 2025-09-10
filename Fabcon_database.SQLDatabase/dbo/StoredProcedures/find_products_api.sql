create   procedure [find_products_api]
    @text nvarchar(max)
    as 
    exec find_products @text
    with RESULT SETS
    (    
        (    
            product_name NVARCHAR(200),    
            product_color NVARCHAR(50),    
            category_name NVARCHAR(50),    
            model_name NVARCHAR(50),    
            product_description NVARCHAR(max),    
            list_price INT,    
            product_weight INT,    
            distance float    
        )
    )

GO

