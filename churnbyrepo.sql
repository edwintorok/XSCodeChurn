-- files ranked by #CA
.print <caption>Repos ranked by #CAs</caption>
with
-- join gitcommit and filechurn for CAs group by uuid
g as (select c.uuid,c.repo,c.date,c.jiratype,c.jiraid,sum(f.churn) as sumchurn from gitcommit c inner join filechurn f on f.uuid=c.uuid where c.date > '2013-01-01' and c.jiratype='CA' group by c.uuid),
-- Get total loc by repo
f as (select repo,sum(loc) as sumloc from filemap group by repo),
-- Get num of CAs and churn by repo 
gr as (select g.repo,count(distinct(g.jiraid)) as cjid,sum(g.sumchurn) as clc from g group by g.repo)

select gr.repo,gr.cjid as "#CAs",gr.clc as "CA LOC churn", fr.sumloc as "LOC",gr.clc*100/fr.sumloc as "% churn",(1000*gr.cjid)/fr.sumloc as "#defects/KLoc" from  gr inner join f fr on fr.repo=gr.repo
order by "#CAs" desc;
