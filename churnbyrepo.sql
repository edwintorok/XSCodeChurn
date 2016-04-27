-- files ranked by #CA
.print <caption>Repos ranked by #CAs</caption>
select c.repo,count(distinct c.uuid) as "#Commits",count(distinct c.jiraid) as "#CAs",sum(f.churn) as "churn (in loc)",loc.sum as "#lines of code",round(sum(f.churn)*100/loc.sum) as "% churn"
from gitcommit c
inner join filechurn f on f.uuid=c.uuid
inner join (select repo,sum(loc) as sum from filemap group by repo) loc on c.repo=loc.repo
where c.jiratype='CA' 
group by c.repo,loc.sum
order by "#CAs" desc;
