--Select repos for given team
with r as (select rp.name as name from repos rp 
left outer join component2team ct
on rp.comp=ct.comp
where ct.team='teamVAR'),
--select * from rp
--order by rp.name;

-- Total churn, CA related churn, #CAs by month 
g as (select strftime('%Y-%m', c.date) as month,c.uuid,c.repo,c.jiratype,c.jiraid,sum(f.added) as sumchurn from gitcommit c inner join filechurn f on f.uuid=c.uuid where c.repo in (select * from r) and c.date > '2013-01-01' group by c.uuid)
--
select g.month as month,'teamVAR',sum(g.sumchurn) as "total LOC churn",sum(j.sumchurn) as "CA LOC Churn", count(distinct(ca.jiraid)) as "#CAs" from  g
left outer join (select uuid,sumchurn from g where jiratype='CA') j
on g.uuid=j.uuid
left outer join (select uuid,jiraid from g where jiratype='CA') ca
on g.uuid=ca.uuid
group by month
order by month;
