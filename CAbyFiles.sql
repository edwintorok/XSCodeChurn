-- files ranked by #CA
\pset title 'Files ranked by #CAs'
select m.filename,count(distinct c.jiraid) as "#CAs"
from filemap m
inner join filechurn f on f.repo=m.repo and f.filename=m.filename
inner join commit c on f.uuid=c.uuid and c.jiratype='CA'
group by m.filename
order by "#CAs" desc;
