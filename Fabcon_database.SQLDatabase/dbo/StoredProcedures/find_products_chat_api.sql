create   procedure [find_products_chat_api]
    @text nvarchar(max)
    as 
    exec find_products_chat @text
    with RESULT SETS
    (    
        (    
            answer NVARCHAR(max)
        )
    )

GO

