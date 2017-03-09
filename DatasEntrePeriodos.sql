declare @startdate datetime = '01/12/2016'
declare @enddate datetime = '08/12/2050'
begin
with 
 N0 as (SELECT 1 as n UNION ALL SELECT 1)
,N1 as (SELECT 1 as n FROM N0 t1, N0 t2)
,N2 as (SELECT 1 as n FROM N1 t1, N1 t2)
,N3 as (SELECT 1 as n FROM N2 t1, N2 t2)
,N4 as (SELECT 1 as n FROM N3 t1, N3 t2)
,N5 as (SELECT 1 as n FROM N4 t1, N4 t2)
,N6 as (SELECT 1 as n FROM N5 t1, N5 t2)
,nums as (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1)) as num FROM N6)
SELECT DATEADD(day,num-1,@startdate) as DhIni, DATEADD(SECOND,86399,DATEADD(day,num-1,@startdate)) DhFim
FROM nums
WHERE num <= DATEDIFF(day,@startdate,@enddate) + 1
end