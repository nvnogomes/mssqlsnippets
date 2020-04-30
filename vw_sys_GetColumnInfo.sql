-- ==============================================================
-- Author:		Nvno Gomes
-- Create date: 20200218
-- Description:	Gets the type of the column by object
-- ==============================================================
CREATE OR ALTER VIEW dbo.sys_ColumnInfo
AS
	SELECT sch.[name]	AS [Schema]
		,obj.[name]		AS [Table]
		,cols.[name]	AS [Column]
		,tps.[name]		As [type]
	FROM [sys].objects obj
		INNER JOIN sys.schemas sch			ON obj.schema_id = sch.schema_id
		INNER JOIN sys.all_columns cols		ON obj.object_id = cols.object_id
		INNER JOIN sys.types tps			ON cols.system_type_id = tps.system_type_id
GO