
-- Create tracking table for migration progress
if OBJECT_ID (N'__migration_status', N'U') IS NOT NULL drop table __migration_status;
create table __migration_status
(
    STEP int,
    ID bigint,
    [NAME]      nvarchar(128),
    [SCHEMA]    nvarchar(128),
    [DBNAME]    nvarchar(128),
    [TABLENAME] nvarchar(128),
    [FULLNAME]  nvarchar(128),
    [ACTION]    nvarchar(max),
    [ROLLBACK]  nvarchar(max),
    NROWS       bigint null,
    KBS         bigint null,
    TIMESTAMP DATETIME NOT NULL DEFAULT(GETDATE()),
    [partition] bit,
    [is_memory_optimized] bit,
        CONSTRAINT [PK__migration_status] 
    PRIMARY KEY CLUSTERED (
        STEP asc,
        ID asc,
        [NAME] asc
    )
);

-- Create target database processing steps
TRUNCATE TABLE [dbo].[__migration_status];

INSERT INTO [dbo].[__migration_status]
 (STEP, ID, [NAME], [FULLNAME], DBNAME, [SCHEMA], TABLENAME)
SELECT 
    2 AS STEP,
    ob.object_id AS ID, 
    QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) AS [NAME],
    QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) AS [FULLNAME],
    TABLE_CATALOG AS DBNAME, 
    TABLE_SCHEMA AS [SCHEMA], 
    TABLE_NAME AS TABLENAME
FROM INFORMATION_SCHEMA.TABLES sc, SYS.objects ob
WHERE 
    sc.TABLE_TYPE = 'BASE TABLE' 
    AND ob.name = sc.TABLE_NAME 
    AND ob.schema_id = SCHEMA_ID(sc.TABLE_SCHEMA)
    AND ob.name not like '__migration_status%'	
    AND NOT EXISTS (
    SELECT 
        1 
    FROM 
        sys.extended_properties 
    WHERE 
        major_id = ob.object_id  
        AND minor_id = 0  
        AND class = 1 
        AND [NAME] = N'microsoft_database_tools_support')

INSERT INTO [dbo].[__migration_status]
(STEP, ID, TABLENAME, [NAME], [SCHEMA], [FULLNAME], [ACTION], [ROLLBACK])
select
    3 as STEP,
    tr.object_id as ID,
    OBJECT_NAME(tr.parent_id) as TABLENAME, 
    object_name(tr.object_id) as [NAME], 
    SCHEMA_NAME(ob.schema_id) as [SCHEMA],
    QUOTENAME(SCHEMA_NAME(ob.schema_id)) + '.' + QUOTENAME(OBJECT_NAME(tr.parent_id)) AS [FULLNAME],
    'disable trigger '+ quotename(object_name(tr.object_id)) + '  on ' + quotename(SCHEMA_NAME(ob.schema_id))  + '.' + quotename(OBJECT_NAME(tr.parent_id)) + ';' AS [ACTION],
    'enable trigger '+ quotename(object_name(tr.object_id)) + '  on ' + quotename(SCHEMA_NAME(ob.schema_id))  + '.' + quotename(OBJECT_NAME(tr.parent_id)) + ';' AS [ROLLBACK]
from sys.triggers tr, sys.objects ob, sys.tables tbl
where 
    tr.is_ms_shipped = 0 
    AND tr.object_id = ob.object_id
    AND tr.parent_id = tbl.object_id
    AND tbl.is_memory_optimized = 0
    AND NOT EXISTS (
    SELECT 
        1 
    FROM 
        sys.extended_properties 
    WHERE 
        major_id = ob.object_id  
        AND minor_id = 0  
        AND class = 1 
        AND [NAME] = N'microsoft_database_tools_support')

 INSERT INTO [dbo].[__migration_status]
(STEP, ID, [SCHEMA], NAME, DBNAME, TABLENAME, [FULLNAME], [ACTION], [ROLLBACK])
SELECT
    4 as STEP,
    stat.object_id as ID, 
    ss.[name] as [SCHEMA],
    stat.[name] AS [NAME],
    db_name() AS DBNAME,
    obj.[name] AS TABLENAME,
    QUOTENAME(ss.[name]) + '.' + QUOTENAME(obj.[name]) AS [FULLNAME],
    'sp_autostats N''' + replace(quotename(ss.[name]) + '.' + quotename(obj.[name]), '''', '''''') + ''', ''OFF'', ' + quotename(stat.[name]) + '' AS [ACTION],
    'sp_autostats N''' + replace(quotename(ss.[name]) + '.' + quotename(obj.[name]), '''', '''''') + ''', ''ON'', ' + quotename(stat.[name]) + '' AS [ROLLBACK]
FROM  
  sys.[objects] AS obj
  INNER JOIN sys.[schemas] ss
    ON obj.[schema_id] = ss.[schema_id]
  INNER JOIN sys.[stats] stat
    ON stat.[object_id] = obj.[object_id]
  INNER JOIN sys.tables tb
    ON obj.object_id = tb.object_id
WHERE 
    obj.[is_ms_shipped] = 0
    AND obj.[name] <> '__migration_status'
    AND stat.no_recompute = 0
    AND tb.is_memory_optimized = 0
    AND NOT EXISTS (
    SELECT 
        1 
    FROM 
        sys.extended_properties 
    WHERE 
        major_id = obj.object_id  
        AND minor_id = 0  
        AND class = 1 
        AND [NAME] = N'microsoft_database_tools_support')

IF (SELECT REPLACE(STR(compatibility_level,3), ' ','0') from sys.databases WHERE  name = DB_NAME()) >= 120
    INSERT INTO [dbo].[__migration_status]
    (STEP, ID, NAME, [SCHEMA], TABLENAME, [FULLNAME], [ACTION], [ROLLBACK])
     SELECT 
        6 as STEP,
        i.object_id as ID,
        i.name as [NAME],
        schema_name(tb.schema_id) as [SCHEMA],
        tb.name as [TABLENAME],
        QUOTENAME(schema_name(tb.schema_id)) + '.' + QUOTENAME(tb.name) AS [FULLNAME],
        'ALTER INDEX ' + quotename(i.name) + ' ON ' + quotename(schema_name(tb.schema_id)) + '.' + quotename(tb.name) + ' DISABLE' as [ACTION],
        'ALTER INDEX ' + quotename(i.name) + ' ON ' + quotename(schema_name(tb.schema_id)) + '.' + quotename(tb.name) + ' REBUILD' as [ROLLBACK]
    FROM sys.indexes i WITH (NOLOCK)
    LEFT JOIN sys.xml_indexes xi WITH (NOLOCK) 
    ON 
        xi.object_id = i.object_id  AND 
        xi.index_id = i.index_id
    INNER JOIN sys.tables tb WITH (NOLOCK) 
    ON 
        i.object_id = tb.object_id
    WHERE
        i.type > 1 
        AND i.type <> 5 
        AND i.is_disabled = 0
        AND tb.is_memory_optimized = 0
        AND NOT EXISTS (
        SELECT 
            1 
        FROM 
            sys.extended_properties 
        WHERE 
            major_id = tb.object_id  
            AND minor_id = 0  
            AND class = 1 
            AND [NAME] = N'microsoft_database_tools_support')
    ORDER BY 
        i.type desc, 
        xi.xml_index_type DESC, 
        i.index_id desc
ELSE 
    INSERT INTO [dbo].[__migration_status]
    (STEP, ID, NAME, [SCHEMA], TABLENAME, [FULLNAME], [ACTION], [ROLLBACK])
    SELECT 
        6 as STEP,
        i.object_id as ID,
        i.name as [NAME],
        schema_name(tb.schema_id) as [SCHEMA],
        tb.name as [TABLENAME],
        QUOTENAME(schema_name(tb.schema_id)) + '.' + QUOTENAME(tb.name) AS [FULLNAME],
        'ALTER INDEX ' + quotename(i.name) + ' ON ' + quotename(schema_name(tb.schema_id)) + '.' + quotename(tb.name) + ' DISABLE' as [ACTION],
        'ALTER INDEX ' + quotename(i.name) + ' ON ' + quotename(schema_name(tb.schema_id)) + '.' + quotename(tb.name) + ' REBUILD' as [ROLLBACK]
    FROM sys.indexes i WITH (NOLOCK)
    INNER JOIN sys.tables tb WITH (NOLOCK) 
    ON 
        i.object_id = tb.object_id
    WHERE 
        i.type > 1
        AND i.type <> 5
        AND i.is_disabled = 0
        AND tb.is_memory_optimized = 0
        AND NOT EXISTS (
        SELECT 
            1 
        FROM 
            sys.extended_properties 
        WHERE 
            major_id = tb.object_id  
            AND minor_id = 0  
            AND class = 1 
            AND [NAME] = N'microsoft_database_tools_support')
    ORDER BY 
        i.type desc, 
        i.index_id desc


INSERT INTO [dbo].[__migration_status]
(STEP, ID, NAME, TABLENAME, [SCHEMA], ACTION, [ROLLBACK], [is_memory_optimized])
SELECT 
    5 AS STEP,
    fk.object_id as ID,
    OBJECT_NAME(fk.object_id) as [NAME],
    tb.name as [TABLENAME],
    schema_name(tb.schema_id) as [SCHEMA],
    'ALTER TABLE '+ quotename(schema_name(tb.schema_id)) +'.' + quotename(tb.name) + ' NOCHECK CONSTRAINT ' + quotename(OBJECT_NAME(fk.object_id)) AS [ACTION], 
    'ALTER TABLE '+ quotename(schema_name(tb.schema_id)) +'.' + quotename(tb.name) + ' CHECK CONSTRAINT ' + quotename(OBJECT_NAME(fk.object_id)) AS [ROLLBACK],
    tb.is_memory_optimized as [is_memory_optimized]
FROM sys.foreign_keys fk WITH (NOLOCK), sys.tables tb
WHERE 
    fk.parent_object_id = tb.object_id 
    and tb.type = 'U'
    and tb.name not like '__migration_status'
    AND fk.is_disabled = 0 ;

-- disable and reenable check constraints
INSERT INTO [dbo].[__migration_status]
(STEP, ID, [NAME], TABLENAME, [SCHEMA], [ACTION], [ROLLBACK], [is_memory_optimized])
SELECT 
    9 AS STEP,
    chk.object_id as ID,
    OBJECT_NAME(chk.object_id) as [NAME],
    tb.name as [TABLENAME],
    schema_name(tb.schema_id) as [SCHEMA],
    'alter table '+ quotename(schema_name(tb.schema_id)) +'.' + quotename(tb.name) + ' NOCHECK CONSTRAINT ' + quotename(OBJECT_NAME(chk.object_id)) AS [ACTION], 
    'alter table '+ quotename(schema_name(tb.schema_id)) +'.' + quotename(tb.name) + ' CHECK CONSTRAINT ' + quotename(OBJECT_NAME(chk.object_id)) AS [ROLLBACK],
    tb.is_memory_optimized as [is_memory_optimized]
FROM sys.check_constraints chk WITH (NOLOCK), sys.tables tb
WHERE 
    chk.parent_object_id = tb.object_id 
    and tb.type = 'U'
    and tb.name not like '__migration_status'
    AND chk.is_disabled = 0 ;

WITH cl_idx_columns as(
    SELECT 
        schema_name(t.schema_id) as [SCHEMA],
        TableName = t.name,
        IndexName = ind.name,
        IndexObjId = ind.object_id,
        ColumnId = ic.index_column_id,
        t.object_id as TABLEOBJID,
        col.name as COLNAME,
        col.system_type_id as COLUMN_TYPE_ID,
        ct.[name] as COLUMN_TYPE_NAME,
        (CASE ic.is_descending_key WHEN 0 THEN 'asc' WHEN 1 THEN 'desc' ELSE '' END) AS ISDESCENDING,
        ROW_NUMBER() OVER(PARTITION BY t.object_id ORDER BY col.system_type_id desc) AS ColumnTypeSort
    FROM 
         sys.indexes ind 
    INNER JOIN 
         sys.index_columns ic ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
    INNER JOIN 
         sys.columns col ON ic.object_id = col.object_id and ic.column_id = col.column_id 
    INNER JOIN 
         sys.tables t ON ind.object_id = t.object_id 
    INNER JOIN
        [sys].[types] ct ON col.system_type_id = ct.system_type_id
    WHERE 
        t.is_ms_shipped = 0 
        and col.is_computed = 0
        and t.name not like '__migration_status%'
        AND (ind.type_desc = 'CLUSTERED' OR ind.type_desc = 'NONCLUSTERED')
        AND ct.system_type_id in (40, 42, 43, 52, 56, 58, 61, 127)
        AND key_ordinal = 1 -- Rows are efficiently searchable on the first indexing key, rest of the keys will result in a table scan
        AND NOT EXISTS (SELECT 
            1 
        FROM 
            sys.extended_properties 
        WHERE 
            major_id = t.object_id  
            AND minor_id = 0  
            AND class = 1 
            AND [NAME] = N'microsoft_database_tools_support')
)
INSERT INTO [dbo].[__migration_status] (STEP, [SCHEMA], TABLENAME, [NAME], ID, DBNAME, [FULLNAME])
SELECT 
    STEP = 31,
    [SCHEMA],
    Tablename,
    COLNAME AS [NAME],
    IndexObjId as ID,
    db_name() as DBNAME,
    QUOTENAME([SCHEMA]) + '.' + QUOTENAME([TABLENAME]) AS [FULLNAME]
FROM cl_idx_columns
WHERE ColumnTypeSort = 1;


WITH CLUSTERINDEXES AS 
(
    SELECT 
         schema_name(t.schema_id) as [SCHEMA],
         TableName = t.name,
         IndexName = ind.name,
         IndexObjId = ind.object_id,
         ColumnId = ic.index_column_id,
         t.object_id as TABLEOBJID,
         col.name as COLNAME,
         (CASE ic.is_descending_key WHEN 0 THEN 'asc' WHEN 1 THEN 'desc' ELSE '' END) AS ISDESCENDING
    FROM 
        sys.indexes ind 
    INNER JOIN 
        sys.index_columns ic ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
    INNER JOIN 
        sys.columns col ON ic.object_id = col.object_id and ic.column_id = col.column_id 
    INNER JOIN 
        sys.tables t ON ind.object_id = t.object_id 
    WHERE 
        t.is_ms_shipped = 0 
        AND col.is_computed = 0
        AND t.name not like '__migration_status%'
        AND (ind.type_desc = 'CLUSTERED' OR ind.type_desc = 'NONCLUSTERED')
        AND ic.key_ordinal = 1 -- Rows are efficiently searchable on the first indexing key, rest of the keys will result in a table scan
        AND NOT EXISTS (SELECT 
            1 
        FROM 
            sys.extended_properties 
        WHERE 
            major_id = t.object_id  
            AND minor_id = 0  
            AND class = 1 
            AND [NAME] = N'microsoft_database_tools_support')
)
INSERT INTO [dbo].[__migration_status]
(STEP, [SCHEMA], DBNAME, TABLENAME, ID, NAME, ACTION, [ROLLBACK])
SELECT 
       20 AS STEP,
       [SCHEMA],
       db_name() AS DBNAME,
       TableName AS [TABLENAME], 
       IndexObjId AS [ID],
       IndexName AS [NAME],
       stuff((select distinct ',' + quotename(colName) 	from CLUSTERINDEXES cix where cix.TableName = ci.TableName and cix.IndexName = ci.IndexName FOR XML PATH(''), TYPE).value('.', 'VARCHAR(MAX)'),1,1,'') as [ACTION],
       stuff((select distinct ',' + quotename(colName)  + ISDESCENDING from CLUSTERINDEXES cix where cix.TableName = ci.TableName and cix.IndexName = ci.IndexName FOR XML PATH(''), TYPE).value('.', 'VARCHAR(MAX)'),1,1,'') as [ROLLBACK]
from CLUSTERINDEXES ci
group by TableName, IndexName, IndexObjId, [SCHEMA];

WITH TABLECOLUMNS AS 
(
    SELECT  
        tb.object_id AS ID, 
        cc.name as [COLNAME], 
        TABLE_CATALOG AS [DBNAME],  
        TABLE_SCHEMA AS [SCHEMA],  
        TABLE_NAME AS TABLENAME, 
        QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) AS TABLEFULLNAME,
        cc.column_id AS [ROLLBACK],
		is_memory_optimized
    FROM 
        INFORMATION_SCHEMA.TABLES sc, 
        SYS.tables tb, 
        SYS.columns cc 
    WHERE 
        cc.is_computed = 0 
        AND tb.name = sc.TABLE_NAME  
        AND tb.name not like '__migration_status%' 
        AND tb.schema_id = SCHEMA_ID(sc.TABLE_SCHEMA) 
        AND cc.object_id = tb.object_id
        AND NOT EXISTS (SELECT 
            1 
        FROM 
            sys.extended_properties 
        WHERE 
            major_id = tb.object_id and 
            minor_id = 0 and 
            class = 1 and 
            [NAME] = N'microsoft_database_tools_support')
)
INSERT INTO [dbo].[__migration_status]
(STEP, [SCHEMA],TABLENAME, ID, [NAME], [FULLNAME], [ACTION])
SELECT 
	21 AS STEP,
	[SCHEMA],
	[TABLENAME], 
	[ID],
	TABLEFULLNAME AS [NAME],
	TABLEFULLNAME as [FULLNAME],
    [ACTION] = 'SELECT ' + stuff((select distinct ',' + QUOTENAME(COLNAME) from TABLECOLUMNS cix where cix.ID = ci.ID FOR XML PATH(''), TYPE).value('.', 'VARCHAR(MAX)'),1,1,'') + ' FROM ' + TABLEFULLNAME +
    CASE
        WHEN is_memory_optimized = 1
            THEN ' WITH (SNAPSHOT)'
            ELSE ''
    END
from TABLECOLUMNS ci
group by TABLENAME, TABLEFULLNAME, ID, [SCHEMA], is_memory_optimized;

--Turn off and on system versioning for temporal tables and their history tables
WITH temporal_mapping AS (
SELECT
    T1.temporal_type as [type],
    T1.object_id as temporalId, 
    QUOTENAME(SCHEMA_NAME(T1.schema_id)) + '.' + QUOTENAME(T1.name) AS TemporalTableName,
    t2.object_id as historyId,
    QUOTENAME(SCHEMA_NAME(T2.schema_id)) + '.' + QUOTENAME(T2.name) AS HistoryTableName,
    T1.is_memory_optimized as [is_memory_optimized]
FROM sys.tables T1  
LEFT JOIN sys.tables T2   
ON 
    T1.history_table_id = T2.object_id  
WHERE 
    T1.temporal_type = 2)

INSERT INTO [dbo].[__migration_status]
(STEP, ID, DBNAME, [SCHEMA], TABLENAME, [NAME], [ACTION], [ROLLBACK], [is_memory_optimized])

SELECT 
    7 AS STEP,
    ob.object_id AS ID, 
    TABLE_CATALOG AS DBNAME,  
    TABLE_SCHEMA AS [SCHEMA], 
    TABLE_NAME AS TABLENAME,
    QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) AS [NAME],
    'ALTER TABLE ' + quotename(TABLE_SCHEMA) + '.' + quotename(TABLE_NAME) + ' SET(SYSTEM_VERSIONING = OFF)' AS [ACTION],
    'ALTER TABLE ' + quotename(TABLE_SCHEMA) + '.' + quotename(TABLE_NAME) + ' SET(SYSTEM_VERSIONING = ON(HISTORY_TABLE = ' + HistoryTableName + '))' AS [ROLLBACK],
    tm.is_memory_optimized as [is_memory_optimized]
FROM INFORMATION_SCHEMA.TABLES sc, SYS.objects ob, temporal_mapping tm
WHERE 
    sc.TABLE_TYPE = 'BASE TABLE' 
    AND ob.name = sc.TABLE_NAME 
    AND ob.schema_id = SCHEMA_ID(sc.TABLE_SCHEMA)
    AND ob.name not like '__migration_status%'
    AND tm.temporalId = ob.object_id;

--Turn off and on period
WITH period_mapping AS (
SELECT 
    T1.object_id, 
    COL_NAME (T1.object_id, start_column_id) as [start_column],
    COL_NAME(T1.object_id, end_column_id) as [end_column],
    T1.is_memory_optimized as [is_memory_optimized]
FROM sys.tables T1   
INNER JOIN sys.periods p
ON T1.object_id = p.object_id)

INSERT INTO [dbo].[__migration_status]
(STEP, ID, DBNAME, [SCHEMA], [TABLENAME], [NAME], [ACTION], [ROLLBACK], [is_memory_optimized])

SELECT 
    8 AS STEP,
    ob.object_id AS ID, 
    TABLE_CATALOG AS DBNAME,  
    TABLE_SCHEMA AS [SCHEMA], 
    TABLE_NAME AS TABLENAME,
    QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) AS [NAME],
    'ALTER TABLE ' + quotename(TABLE_SCHEMA) + '.' + quotename(TABLE_NAME) + ' DROP PERIOD FOR SYSTEM_TIME' AS [ACTION],
    'ALTER TABLE ' + quotename(TABLE_SCHEMA) + '.' + quotename(TABLE_NAME) + ' ADD PERIOD FOR SYSTEM_TIME(' + quotename(start_column) + ',' + quotename(end_column) + ')' AS [ROLLBACK],
    pm.is_memory_optimized as [is_memory_optimized]
FROM INFORMATION_SCHEMA.TABLES sc, SYS.objects ob, period_mapping pm
WHERE 
    sc.TABLE_TYPE = 'BASE TABLE' 
    AND ob.name = sc.TABLE_NAME 
    AND ob.schema_id = SCHEMA_ID(sc.TABLE_SCHEMA)
    AND ob.name not like '__migration_status%'
    AND pm.object_id = ob.object_id;

-- Pre-copy database level operations for non-memory optimized tables
DECLARE @command nvarchar(MAX)
DECLARE action_cursor CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY
FOR 
SELECT [ACTION] FROM [dbo].[__migration_status]
where STEP in (5,7,8,9)
and is_memory_optimized = 0
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
DEALLOCATE action_cursor
