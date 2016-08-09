-- diff chunks changed by CAs
-- ranked by number of CAs involved
select c.context,c.filename,c.repo,count(c.uuid) as count
from filemap m, chunk c
-- filters on CA
where c.uuid in 
	(select  uuid from gitcommit where jiratype='CA')
-- filter on file still existing (for when repo have been split)
and c.repo=m.repo and c.filename=m.filename
group by c.context,c.repo,c.filename
order by count desc;
