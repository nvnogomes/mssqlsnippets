USE msdb;
GO

IF OBJECT_ID('[dbo].[JobChanges]') IS NOT NULL 
  DROP TABLE [dbo].[JobChanges]
;

-- Add the table
CREATE TABLE [dbo].[JobChanges] (
  [ID]			[INT] IDENTITY(1,1) NOT NULL,
  [EditDate]	[datetime2](0) NOT NULL,
  [ChangeType]	[Nvarchar](20) NOT NULL,
  [JobName]		[Nvarchar](20) NOT NULL,
  [Enabled]		[TinyInt] NOT NULL,
  [PerformedBy] [nvarchar](256) NOT NULL,
  [XML_RECSET]	[xml] NULL,
	CONSTRAINT [PK_AJC_AuditChangeID] PRIMARY KEY CLUSTERED ([ID] ASC)
);
GO

ALTER TABLE [dbo].[JobChanges] 
ADD CONSTRAINT [DF_AJC_AuditChangeDate] DEFAULT (getdate()) FOR [EditDate];
ALTER TABLE [dbo].[JobChanges] 
ADD CONSTRAINT [DF_AJC_AuditChangeType] DEFAULT ('Unknown') FOR [ChangeType];
ALTER TABLE [dbo].[JobChanges] 
ADD CONSTRAINT [DF_AJC_AuditChangePerformedBy] DEFAULT (COALESCE(suser_sname(),'Unknown')) FOR [PerformedBy];
ALTER TABLE [dbo].[JobChanges] 
ADD CONSTRAINT [DF_AJC_Enabled] DEFAULT (1) FOR [Enabled];
ALTER TABLE [dbo].[JobChanges] 
ADD CONSTRAINT [DF_AJC_JobName] DEFAULT (coalesce(host_name(),'Unknown')) FOR [JobName];
GO

/************************************************************************************/
CREATE OR ALTER TRIGGER [dbo].[TRIGGER_sysjobs]
ON [dbo].[sysjobs]
FOR INSERT, UPDATE, DELETE
AS
BEGIN

	;WITH allChanges
	AS (
		SELECT *
			,(select * from inserted for xml path('RecordSet'), TYPE) details
		FROM inserted
		UNION ALL
		SELECT *
			,(select * from deleted for xml path('RecordSet'), TYPE) details
		FROM deleted
	)
	INSERT INTO dbo.[JobChanges] (EditDate, ChangeType,[JobName], [Enabled], PerformedBy,XML_RECSET)
	SELECT GETDATE()
		, CASE
			WHEN EXISTS (select * from inserted) AND NOT EXISTS (select * from deleted) THEN 'INSERT'
			WHEN NOT EXISTS (select * from inserted) AND EXISTS (select * from deleted) THEN 'DELETE'
			ELSE 'UPDATE'
		END +' Job'
		,i.[name]
		,i.[enabled]
		,suser_sname()
		,i.details
	FROM allChanges i
END
GO


/************************************************************************************/
CREATE OR ALTER TRIGGER [dbo].[TRIGGER_sysjobsteps]
ON [dbo].[sysjobsteps]
FOR INSERT, UPDATE, DELETE
AS
BEGIN

	;WITH allChanges
	AS (
		SELECT *
			,(select * from inserted for xml path('RecordSet'), TYPE) details
		FROM inserted
		UNION ALL
		SELECT *
			,(select * from deleted for xml path('RecordSet'), TYPE) details
		FROM deleted
	)
	INSERT INTO dbo.[JobChanges] (EditDate, ChangeType,[JobName], [Enabled], PerformedBy,XML_RECSET)
	SELECT GETDATE()
		, CASE
			WHEN EXISTS (select * from inserted) AND NOT EXISTS (select * from deleted) THEN 'INSERT'
			WHEN NOT EXISTS (select * from inserted) AND EXISTS (select * from deleted) THEN 'DELETE'
			ELSE 'UPDATE'
		END +' Step'
		,sj.[name] +'.'+ i.step_name
		,sj.[enabled]
		,suser_sname()
		,i.details
	FROM allChanges i
		INNER JOIN dbo.sysjobs sj ON i.job_id = sj.job_id
END
GO


/************************************************************************************/
CREATE OR ALTER TRIGGER [dbo].[TRIGGER_sysjobschedules]
ON [dbo].[sysjobschedules]
FOR INSERT, UPDATE, DELETE
AS
BEGIN
	;WITH allChanges
	AS (
		SELECT *
			,(select * from inserted for xml path('RecordSet'), TYPE) details
		FROM inserted
		UNION ALL
		SELECT *
			,(select * from deleted for xml path('RecordSet'), TYPE) details
		FROM deleted
	)
	INSERT INTO dbo.[JobChanges] (EditDate, ChangeType,[JobName], [Enabled], PerformedBy,XML_RECSET)
	SELECT GETDATE()
		, CASE
			WHEN EXISTS (select * from inserted) AND NOT EXISTS (select * from deleted) THEN 'INSERT'
			WHEN NOT EXISTS (select * from inserted) AND EXISTS (select * from deleted) THEN 'DELETE'
			ELSE 'UPDATE'
		END +' Schedule'
		,sj.[name] +'.'+ ss.[name]
		,ss.[enabled]
		,suser_sname()
		,i.details
	FROM allChanges i
		INNER JOIN dbo.sysjobs sj ON i.job_id = sj.job_id
		INNER JOIn dbo.sysschedules ss ON i.schedule_id = ss.schedule_id
END
GO





