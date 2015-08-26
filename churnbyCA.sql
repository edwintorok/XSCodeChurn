-- Filenames changed by CAs
-- with total code churn
-- ranked by number of CAs involved
select filechurn.filename,count(filechurn.uuid) as count,sum(filechurn.churn) as total,filemap.loc
from filechurn  
full join filemap on filechurn.filename = filemap.filename
where filechurn.uuid in 
	(select uuid from commit where jiratype='CA')
group by filechurn.filename,filemap.loc
order by count desc;
