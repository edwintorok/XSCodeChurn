-- Filenames changed by CAs
-- with total code churn
-- ranked by number of CAs involved
select f.filename,f.repo,count(f.uuid) as count,sum(f.churn) as total,m.loc as loc,round(sum(f.churn)*100/m.loc) as percent
from filechurn f,filemap m  
where f.uuid in 
	(select  uuid from commit where jiratype='CA')
and f.repo=m.repo and f.filename=m.filename
group by f.repo,f.filename,m.loc
order by count desc;
