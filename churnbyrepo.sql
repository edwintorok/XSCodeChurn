-- files ranked by #CA
.print <caption>Repos ranked by #CAs</caption>
-- select c.repo,count(distinct c.uuid) as "#Commits",count(distinct c.jiraid) as "#CAs",sum(f.churn) as "churn (in loc)",loc.sum as "#lines of code",round(sum(f.churn)*100/loc.sum) as "% churn",1000*count(distinct c.jiraid)/loc.sum as "#defects/KLoc"
--from gitcommit c
--inner join filechurn f on f.uuid=c.uuid
--inner join (select repo,sum(loc) as sum from filemap group by repo) loc on c.repo=loc.repo
--where c.jiratype='CA' 
--group by c.repo,loc.sum
--order by "#CAs" desc;
-- Total churn, CA related churn, #CAs by month 
with g as (select c.uuid,c.repo,c.date,c.jiratype,c.jiraid,sum(f.churn) as sumchurn from gitcommit c inner join filechurn f on f.uuid=c.uuid where c.jiratype='CA' group by c.uuid)
--select g.date,g.repo as repo ,g.sumchurn as "total LOC churn", g.jiraid as "#CAs" from  g
select g.repo as repo ,count(distinct(g.uuid)) as "#commits",count(distinct(g.jiraid)) as "#CAs",sum(g.sumchurn) as "CA LOC churn", fm.sumloc as "LOC",sum(g.sumchurn)*100/fm.sumloc as "% churn",(1000*count(distinct(g.jiraid)))/fm.sumloc as "#defects/KLoc" from  g
inner join (select repo,sum(loc) as sumloc from filemap group by repo) fm on g.repo=fm.repo
group by g.repo
order by "#CAs" desc;
