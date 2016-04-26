-- diff chunks changed by CAs
-- ranked by number of CAs involved
-- \pset title 'commit diff chunks (~function name) ranked by #CAs'
select ch.context,m.filename,m.repo,count(distinct ch.uuid) as "#commits",count(distinct c.jiraid) as "#CAs"
from chunk ch
inner join gitcommit c on ch.uuid=c.uuid and c.jiratype='CA'
inner join filemap m on ch.repo=m.repo and ch.filename=m.filename
group by ch.context,m.filename,m.repo
order by "#CAs" desc;
