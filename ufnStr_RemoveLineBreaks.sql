IF OBJECT_ID(N'dbo.ufnStr_RemoveLineBreaks', N'TF') IS NOT NULL
    DROP FUNCTION [dbo].[ufnStr_RemoveLineBreaks];
GO
/********************************************************
 * Description:	Returns the given string capitalized
 * Creator:		Nuno Gomes
 * Date:		2018-06-19
 *******************************************************/
CREATE FUNCTION [dbo].[ufnStr_RemoveLineBreaks] (
    @string NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    RETURN REPLACE(REPLACE(@string, CHAR(13), ''), CHAR(10), '')
END
