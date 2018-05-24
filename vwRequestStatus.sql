IF OBJECT_ID('[dbo].[vwRequestStatus]', 'V') IS NOT NULL 
  DROP VIEW [dbo].[vwRequestStatus]; 

/**************************************************************
 * Description:	Get status and information of active requests
 * Creator:		Nuno Gomes
 * Date:		2018-05-24
 *************************************************************/
CREATE VIEW [dbo].[vwRequestStatus]
AS
	SELECT sqltext.TEXT					[Query]
		,req.command					[Command]
		,req.[status]					[Status]
		,sess.[login_name]				[User]
		,req.cpu_time					[CPU Time]
		,req.total_elapsed_time%60		[Elapsed Time (s)]
		,(DATEDIFF(s,start_time,GetDate())%60) [Running Time (s)]
		,req.wait_time%60				[Waiting Time (s)]
		,req.row_count					[Row Count]
		,req.session_id					[SessionId]
		,DB_NAME(req.database_id)		[Database]
		,USER_NAME(req.user_id)			[Schema]
		,req.[language]					[Language]
		,req.transaction_id				[Transaction Id]
		,sess.[host_name]				[Hostname]
		,sess.[program_name]			[Program]
	FROM sys.dm_exec_requests req
		LEFT JOIN sys.dm_exec_sessions sess ON req.session_id = sess.session_id
		CROSS APPLY sys.dm_exec_sql_text(sql_handle) sqltext
