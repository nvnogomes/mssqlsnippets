-- =============================================
-- Author:		Nuno Gomes
-- Create date: 20190402
-- Description:	Convert nvarchar to base64
-- =============================================
CREATE OR ALTER FUNCTION dbo.ConvertToBase64(@str NVARCHAR(100))
RETURNS NVARCHAR(100)
AS
BEGIN
	DECLARE @base64Hash NVARCHAR(100);

	SET @base64Hash = (SELECT CAST(@str AS varbinary(max)) FOR XML PATH(''), BINARY BASE64)

	RETURN @base64Hash;
END;
GO