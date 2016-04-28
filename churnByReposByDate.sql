-- ranked by number of CAs involved
.print <caption>#commits & churn by repos by date</caption>
with g as (select * from gitcommit c inner join filechurn f on f.uuid=c.uuid where c.repo='xen-api.git')
select g.date as "date", g.repo as "repo",count(distinct g.uuid) as "#total commits",count(distinct j.jiraid) as "#CA commits",sum(g.churn) as "churn",sum(j.churn) as "CA churn"
from  g
left outer join (select uuid,jiraid,churn from g where repo='xen-api.git' and jiratype='CA') j
on g.uuid=j.uuid
group by g.date
order by g.date desc;
