-- ranked by number of CAs involved
.print <caption>#commits & churn by repos by date</caption>
select g.date as "date", g.repo as "repo",count(distinct g.uuid) as "#total commits",count(distinct j.jiraid) as "#CA commits",sum(g.churn) as "churn",sum(j.churn) as "CA churn"
from (select * from gitcommit c inner join filechurn f on f.uuid=c.uuid where c.repo='xen-api.git') g
left outer join (select c.uuid,c.jiraid,f.churn from gitcommit c inner join filechurn f on f.uuid=c.uuid where c.repo='xen-api.git' and c.jiratype='CA') j
on g.uuid=j.uuid
group by g.date
order by g.date desc;
