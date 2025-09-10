CREATE   PROCEDURE [dbo].[prompt_answer]
@user_question nvarchar(max),
@products nvarchar(max),
@answer nvarchar(max) output

AS

declare @url nvarchar(4000) = N'https://nibal-m9ps47io-eastus2.openai.azure.com/openai/deployments/gpt-4/chat/completions?api-version=2024-06-01';
declare @payload nvarchar(max) = N'{
    "messages": [
        {
            "role": "system",
            "content": "You are a sales assistant who helps customers find the right products for their question and activities."
        },
        {
            "role": "user",
            "content": "The products available are the following: ' + @products + '"
        },
        {
            "role": "user",
            "content": " ' + @user_question + '"
        }
    ]
}';

declare @ret int, @response nvarchar(max);

exec @ret = sp_invoke_external_rest_endpoint
    @url = @url,
    @method = 'POST', 
    @payload = @payload,
    @credential = [https://nibal-m9ps47io-eastus2.openai.azure.com/],    
    @timeout = 230,
    @response = @response output;

select json_value(@response, '$.result.choices[0].message.content');

GO

