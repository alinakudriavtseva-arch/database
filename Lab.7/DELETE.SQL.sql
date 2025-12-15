-- 1. Видалення всіх FOREIGN KEY (Зв'язків)
DECLARE @sql NVARCHAR(MAX) = N'';
SELECT @sql = @sql + 
'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id))
+ '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) 
+ ' DROP CONSTRAINT ' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.foreign_keys;
EXEC (@sql);

-- 2. Видалення всіх таблиць
DECLARE @sqlTables NVARCHAR(MAX) = N'';
SELECT @sqlTables = @sqlTables + 
'DROP TABLE ' + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.tables;
EXEC (@sqlTables);

PRINT 'All tables and constraints have been deleted successfully.';