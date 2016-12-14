-- Find the tests that found CAs by given files
with 
	g as (select c.uuid,c.jiraid,t.*
	from tests t
	inner join gitcommit c on t.jiraid=c.jiraid and c.jiratype=t.jiratype
	where t.tc_id != ''),

	ch as (select uuid,repo,filename from chunk)
select distinct ch.*,g.* from ch
inner join g
on ch.uuid=g.uuid
order by ch.filename desc;
--select * from g;
