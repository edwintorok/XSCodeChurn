-- ranked by number of CAs involved
.print <caption>#commits by repos by date</caption>
select g.date as "date", g.repo as "repo",count(distinct g.uuid) as "#total commits",count(distinct j.jiraid) as "#CA commits"
from gitcommit g inner join 
	(select * from gitcommit where jiratype='CA') j
on g.date=j.date
group by g.repo,g.date
order by g.date asc;
