
--7: Create procedure to insert product_review_feedback
CREATE   PROCEDURE [dbo].[ins_product_review_feedback]
 @ProductID int,
 @reviewid int,
 @employee_id int
AS
BEGIN
    INSERT INTO dbo.product_review_feedback(ProductID, ReviewID, employee_ID)
    values(@ProductID, @reviewid, @employee_id)
END;

GO

