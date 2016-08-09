-- files ranked by #CA
.print <caption>Files ranked by #CAs</caption>
select f.filename,count(distinct c.jiraid) as "#CAs"
from filechurn f
inner join filemap m on f.repo=m.repo and f.filename=m.filename
inner join gitcommit c on f.uuid=c.uuid and c.jiratype='CA'
group by f.filename
order by "#CAs" desc;
