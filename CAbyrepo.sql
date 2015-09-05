-- ranked by number of CAs involved
\pset title 'repos by number of CAs'
select repo,count(distinct jiraid) as "#CAs"
from commit 
where jiratype='CA'
group by repo
order by  "#CAs" desc;