-- =============================================
-- Migration Script: V001 - Initial Schema
-- Description: Initial database schema migration
-- Version: 1.0.0
-- Author: Workshop Team
-- Created: 2024
-- =============================================

-- Create migration tracking table if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SchemaVersions]') AND type in (N'U'))
BEGIN
    CREATE TABLE dbo.SchemaVersions (
        VersionID INT IDENTITY(1,1) PRIMARY KEY,
        Version NVARCHAR(20) NOT NULL UNIQUE,
        Description NVARCHAR(255),
        AppliedDate DATETIME2 DEFAULT GETDATE(),
        AppliedBy NVARCHAR(100) DEFAULT SYSTEM_USER
    );
    
    PRINT 'SchemaVersions table created';
END

-- Check if this migration has already been applied
IF NOT EXISTS (SELECT 1 FROM dbo.SchemaVersions WHERE Version = '1.0.0')
BEGIN
    -- Apply migration changes here
    -- (In a real scenario, you would include the schema creation scripts here
    -- or reference them from the schemas folder)
    
    PRINT 'Applying migration V001 - Initial Schema';
    
    -- Record this migration as applied
    INSERT INTO dbo.SchemaVersions (Version, Description)
    VALUES ('1.0.0', 'Initial database schema with core tables');
    
    PRINT 'Migration V001 applied successfully';
END
ELSE
BEGIN
    PRINT 'Migration V001 already applied, skipping';
END