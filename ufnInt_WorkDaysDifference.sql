SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nuno Gomes
-- Create date: 2019-09-18
-- Description:	Returns workdays passed
-- =============================================
CREATE OR ALTER FUNCTION dbo.WorkDaysDifference (
	@startDate	DATETIME,
	@endDate	DATETIME
)
RETURNS INT
WITH RETURNS NULL ON NULL INPUT
AS
BEGIN

	-- switch dates if start after end
	IF @startDate > @endDate
	BEGIN
		DECLARE @aux	DATETIME = @startDate
		SET @startDate = @endDate;
		SET @endDate = @aux;
	END

	/* To the day difference, if start and end belong to differente weeks remove weekend days
	 * if start date is during the weekend remove one day to the week difference
	 * the comparison must be by name as the week may be set to start at sunday or monday (SET DATEFIRST #)
	 * if the end date is a saturday remove one day
	 */
	RETURN (DATEDIFF(DAY,@startDate, @endDate))
			-(DATEDIFF(WEEK,@startDate, @endDate)*2
			- CASE WHEN DATENAME(WEEKDAY,@startDate) IN ('Sunday','Saturday')
				THEN 1
				ELSE 0
			END)
			- CASE WHEN DATENAME(WEEKDAY,@endDate) = 'Saturday'
				THEN 1
				ELSE 0
			END;
END;
GO
