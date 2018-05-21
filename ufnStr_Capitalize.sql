CREATE FUNCTION [dbo].[ufnStr_Capitalize] (
    @string NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    RETURN UPPER(LEFT(@string,1))+LOWER(SUBSTRING(@string,2,LEN(@string)))
END
