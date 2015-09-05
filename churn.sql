-- files ranked by #CA
\pset title 'Files ranked by #CAs'
select m.filename,m.repo,count(distinct f.uuid) as "#Commits",count(distinct c.jiraid) as "#CAs",sum(f.churn) as "churn (in loc)",m.loc as "#lines of code" ,round(sum(f.churn)*100/m.loc) as "% churn"
from filemap m
inner join filechurn f on f.repo=m.repo and f.filename=m.filename
inner join commit c on f.uuid=c.uuid and c.jiratype='CA'
group by m.filename,m.repo,m.loc
order by "#CAs" desc;
