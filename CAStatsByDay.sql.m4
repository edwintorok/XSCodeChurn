-- Total churn, CA related churn, #CAs by month 
with g as (select c.uuid,c.repo,c.date,c.jiratype,c.jiraid,sum(f.churn) as sumchurn from gitcommit c inner join filechurn f on f.uuid=c.uuid where c.repo='repoVar' and c.date > '2013-01-01' group by c.uuid)
-- select g.month,g.uuid,g.repo,g.date,g.jiratype,g.jiraid,g.sumchurn,j.sumchurn,ca.jiraid from  g
select g.date,g.repo as repo ,sum(g.sumchurn) as "total LOC churn",sum(j.sumchurn) as "CA LOC Churn", count(distinct(ca.jiraid)) as "#CAs" from  g
left outer join (select uuid,sumchurn from g where jiratype='CA') j
on g.uuid=j.uuid
left outer join (select uuid,jiraid from g where jiratype='CA') ca
on g.uuid=ca.uuid
group by date
order by date;
