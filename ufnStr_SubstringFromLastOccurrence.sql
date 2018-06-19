IF OBJECT_ID(N'dbo.ufnStr_SubstringFromLastOccurrence', N'TF') IS NOT NULL
    DROP FUNCTION [dbo].[ufnStr_SubstringFromLastOccurrence];
GO
/********************************************************
 * Description:	Returns string from the last occurrence of the given char
 * Creator:		Nuno Gomes
 * Date:		2018-06-19
 *******************************************************/
CREATE FUNCTION [dbo].[ufnStr_SubstringFromLastOccurrence](@hay VARCHAR(MAX), @needle CHAR(1))
RETURNS VARCHAR(MAX)
AS
BEGIN
	RETURN SUBSTRING(@hay, (LEN(@hay) - CHARINDEX(@needle,REVERSE(@hay))+2), LEN(@hay))
END