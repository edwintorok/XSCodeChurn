-- Find the tests that found CAs by given files
-- This is the postgres version
with 
	g as (select c.uuid,c.jiraid,t.*
	from tests t
	inner join gitcommit c on t.jiraid=c.jiraid and c.jiratype=t.jiratype
	where t.tc_id != ''),

	tc as (select distinct ch.filename,ch.repo,g.*
	from chunk ch
	inner join g on ch.uuid=g.uuid
	where ch.filename=:'FILENAME')

select row_to_json(tc.*) from tc
order by tc.filename desc;
