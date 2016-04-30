-- ranked by number of CAs involved
.print <caption>#commits & churn by repos by date</caption>
with g as (select * from gitcommit c inner join filechurn f on f.uuid=c.uuid where c.repo='xen-api.git')
select strftime('%Y-%m', g.date) as "month",g.date as "date", g.repo as "repo",count(distinct g.uuid) as "#total commits",count(distinct j.jiraid) as "#CAs",sum(g.churn) as "total LOC churn",sum(j.churn) as "CA LOC churn"
from  g
left outer join (select uuid,jiraid,churn from g where repo='xen-api.git' and jiratype='CA') j
on g.uuid=j.uuid
group by g.date
order by g.date desc;
