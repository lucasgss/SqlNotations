SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Lucas Soares
-- Create date: 06/02/2017
-- Description:	Obter todos os dias entre periodo passado.
-- Ref.: https://stackoverflow.com/questions/1378593/get-a-list-of-dates-between-two-dates-using-a-function 
-- =============================================
CREATE FUNCTION [dbo].[ObtemDias]
(	
	@DhInicio datetime, 
	@DhFim datetime
)
RETURNS TABLE 
AS
RETURN 
(
with 
 N0 as (SELECT 1 as n UNION ALL SELECT 1)
,N1 as (SELECT 1 as n FROM N0 t1, N0 t2)
,N2 as (SELECT 1 as n FROM N1 t1, N1 t2)
,N3 as (SELECT 1 as n FROM N2 t1, N2 t2)
,N4 as (SELECT 1 as n FROM N3 t1, N3 t2)
,N5 as (SELECT 1 as n FROM N4 t1, N4 t2)
,N6 as (SELECT 1 as n FROM N5 t1, N5 t2)
,nums as (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1)) as num FROM N6)
, tblDates as (SELECT DATEADD(day,num-1,@DhInicio) as DhInicio, DATEADD(SECOND,86399,DATEADD(day,num-1,@DhInicio)) DhFim
					FROM nums WHERE num <= DATEDIFF(day,@DhInicio,@DhFim) + 1) --Tabela com todas as datas dentro do período.
select convert(date,tblDates.DhInicio) 'DhInicio', convert(datetime,tblDates.DhFim) 'DhFim' from tblDates
)

GO
