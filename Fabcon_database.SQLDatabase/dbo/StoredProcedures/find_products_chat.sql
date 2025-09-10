create   procedure [dbo].[find_products_chat]
@text nvarchar(max),
@top int = 3,
@min_similarity decimal(19,16) = 0.70
as
if (@text is null) return;
declare @retval int, @qv vector(1536), @products_json nvarchar(max), @answer nvarchar(max);
exec @retval = dbo.create_embeddings @text, @qv output;
if (@retval != 0) return;
with vector_results as (
SELECT 
        p.Name as product_name,
        ISNULL(p.Color,'No Color') as product_color,
        c.Name as category_name,
        m.Name as model_name,
        d.Description as product_description,
        p.ListPrice as list_price,
        p.weight as product_weight,
        vector_distance('cosine', @qv, p.embeddings) AS distance
FROM
    [SalesLT].[Product] p,
    [SalesLT].[ProductCategory] c,
    [SalesLT].[ProductModel] m,
    [SalesLT].[vProductAndDescription] d
where p.ProductID = d.ProductID
and p.ProductCategoryID = c.ProductCategoryID
and p.ProductModelID = m.ProductModelID
and p.ProductID = d.ProductID
and d.Culture = 'en')
select
top(@top)
@products_json = (STRING_AGG (CONVERT(NVARCHAR(max),CONCAT( 
                                product_name, ' ' ,
                                product_color, ' ',
                                category_name, ' ', 
                                model_name, ' ', 
                                product_description, ' ',
                                list_price, ' ',
                                product_weight )), CHAR(13)))
from vector_results
where (1-distance) > @min_similarity
group by distance
order by    
    distance asc;

set @products_json = (select REPLACE(REPLACE(@products_json, CHAR(13), ' , '), CHAR(10), ' , '));

exec [dbo].[prompt_answer] @text, @products_json, @answer output;

GO

