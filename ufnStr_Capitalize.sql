IF OBJECT_ID(N'dbo.ufnStr_Capitalize', N'TF') IS NOT NULL
    DROP FUNCTION [dbo].[ufnStr_Capitalize];
GO
/********************************************************
 * Description:	Returns the given string capitalized
 * Creator:		Nuno Gomes
 * Date:		2018-07-27
 *******************************************************/
CREATE FUNCTION [dbo].[ufnStr_Capitalize] (
    @string NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    RETURN UPPER(LEFT(@string,1))+LOWER(SUBSTRING(@string,2,LEN(@string)))
END