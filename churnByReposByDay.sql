-- ranked by number of CAs involved
.print <caption>#commits & churn by repos by date</caption>
with g as (select strftime('%Y-%m', c.date) as month,c.uuid,c.repo,c.date,c.jiratype,c.jiraid,sum(f.churn) as sumchurn from gitcommit c inner join filechurn f on f.uuid=c.uuid where c.repo='xen-api.git' group by c.uuid)
select g.month,g.uuid,g.repo,g.date,g.jiratype,g.jiraid,g.sumchurn,j.sumchurn from  g
left outer join (select uuid,sumchurn from g where jiratype='CA') j
on g.uuid=j.uuid
-- group by g.date
order by g.date desc;
