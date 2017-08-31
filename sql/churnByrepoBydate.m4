.print <caption>Code churn by repo between 'm4BeginDate' and 'm4EndDate'</caption>
with 
c as (select uuid,date from gitcommit where date between  date('m4BeginDate') and date('m4EndDate')),
f2 as (select * from filechurn f inner join c on c.uuid=f.uuid where f.type=1)
select repo, sum(added) from f2
group by repo
order by repo;
