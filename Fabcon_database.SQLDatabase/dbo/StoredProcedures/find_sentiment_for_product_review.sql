CREATE   PROCEDURE [dbo].[find_sentiment_for_product_review]
 @text NVARCHAR(MAX),
 @reviewid int
AS
BEGIN
    -- Check if the search query is NULL, if so, exit the procedure
    IF (@text IS NULL) RETURN;

    DECLARE @RefinedQuery NVARCHAR(MAX);
    DECLARE @LLMResponse NVARCHAR(MAX);
    DECLARE @LLMRetval INT;
    DECLARE @LLMPayload NVARCHAR(MAX);

    -- Prepare the payload for the Language Model API call
    SET @LLMPayload = 
    N'{
        "model": "gpt-4.1",
        "messages": [
            {
                "role": "system",
                "content": "You are an expert at scoring sentiment.  You will examine the product name, product description, and the customer review to determine sentiment.  Remember that the product name and product description can provide context to the review.  You will return one of these values, the review will be Positive, Neutral, or Negative."
            },
            {
                "role": "user",
                "content": "'+@text+'"
            }
        ],
        "max_completion_tokens": 800,
        "temperature": 1.0,
        "top_p": 1.0,
        "frequency_penalty": 0.0,
        "presence_penalty": 0.0,
        "model": "deployment"
    }';

    -- Call the external REST endpoint to interact with the Language Model
    EXEC @LLMRetval = sp_invoke_external_rest_endpoint
         @url = 'https://ai-ready-apps.openai.azure.com/openai/deployments/gpt-4.1/chat/completions?api-version=2025-01-01-preview',
         @method = 'POST',
         @credential = [https://ai-ready-apps.openai.azure.com/],
         @payload = @LLMPayload,
         @response = @LLMResponse OUTPUT;

    -- Extract the refined query from the LLM response JSON
    SET @RefinedQuery = JSON_VALUE(@LLMResponse, '$.result.choices[0].message.content');

    -- If the refined query is NULL or empty, use the original search query
    IF (@RefinedQuery IS NULL OR LEN(@RefinedQuery) = 0)
        begin
            SET @RefinedQuery = @text;
        end
    
    --Update Product Reviews with the Sentiment Score
    update dbo.product_reviews
    set SentimentLabel = @RefinedQuery
    where
        ReviewID=@reviewid

    --print 'refinedquery: ' + @RefinedQuery
END;

GO

