
/********************************************************************************
 *							Lesson 1: Authentication							*
 ********************************************************************************/
-- Windows Login
CREATE LOGIN [ALTAMIRAAM\GUEST007]
FROM WINDOWS
WITH DEFAULT_DATABASE = [WideWorldImporters];
GO

-- SQL Server login
CREATE LOGIN WWI_Tester
WITH PASSWORD = 'WWI2019tester' MUST_CHANGE, -- when MUST_CHANGE used CHECK_POLICY must be on
	DEFAULT_DATABASE = [WideWorldImporters],
	CHECK_POLICY = ON,
	CHECK_EXPIRATION = ON;
GO




-- check mssql instance logins
SELECT *
FROM sys.syslogins; -- SQLServer 2000
SELECT *
FROM sys.server_principals;



-- ### Fix 


