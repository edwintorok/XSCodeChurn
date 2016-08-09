-- ranked by number of CAs involved
.print <caption>repos by number of CAs</caption>
select repo,count(distinct jiraid) as "#CAs"
from gitcommit 
where jiratype='CA'
group by repo
order by  "#CAs" desc;
