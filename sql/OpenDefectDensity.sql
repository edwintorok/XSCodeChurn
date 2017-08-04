-- files ranked by #CA
.print <caption>Open Defect density, per team, with coefficients blocker*5+critical*3+major*1+minor*0.5+trivial*0.5</caption>
with 
OpenDefects as (select team,blocker*5+critical*3+major*1+minor*0.5+trivial*0.5 as total from OpenCAs),
SumOpenDefects as (select sum(blocker)*5+sum(critical)*3+sum(major)+sum(minor)*0.5+sum(trivial)*0.5 as total from OpenCAs),
KLOC as (select sum(loc)/1000 as total from filemap)
-- totalLOC as (select sum(loc) as sloc from filemap)
-- .print <caption>Total LOC for all repos</caption>
select * from OpenDefects as "Total Open Defects"
union all
select "TOTAL Kloc",total from KLOC
union all
select "TOTAL Open Defects",total from SumOpenDefects
union all
select "TOTAL Open Defects Density per Kloc", SumOpenDefects.total/KLOC.total from KLOC,SumOpenDefects
-- .print <caption>Total Open Density for all teams/repos</caption>
-- select 

