-- Filenames changed by CAs
-- with total code churn
-- ranked by number of CAs involved
select filechurn.filename,filechurn.repo,count(filechurn.uuid) as count,sum(filechurn.churn) as total,filemap.loc
from filechurn,filemap  
where filechurn.uuid in 
	(select  uuid from commit where jiratype='CA')
and filechurn.repo=filemap.repo and filechurn.filename=filemap.filename
group by filechurn.repo,filechurn.filename,filemap.loc
order by count desc;
