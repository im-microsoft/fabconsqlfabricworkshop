
-- Post-copy database level operations for non-memory optimized tables
DECLARE @command nvarchar(MAX)
DECLARE action_cursor CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY
FOR 
SELECT [ROLLBACK] FROM [dbo].[__migration_status]
WHERE STEP IN (5,7,8,9)
AND is_memory_optimized = 0
ORDER BY STEP DESC
OPEN action_cursor
BEGIN TRANSACTION
BEGIN TRY
FETCH NEXT FROM action_cursor INTO @command
WHILE @@FETCH_STATUS = 0
BEGIN 
    EXECUTE sp_executesql @command
    FETCH NEXT FROM action_cursor INTO @command
END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
        THROW
END CATCH
IF @@TRANCOUNT > 0
    COMMIT TRANSACTION
CLOSE action_cursor
DEALLOCATE action_cursor;

-- Delete tracking table for migration progress
if OBJECT_ID (N'__migration_status', N'U') IS NOT NULL drop table __migration_status;
