-- files ranked by #CA
.print <caption>Defect density and churn by files ranked by #CAs</caption>
with
g as (select c.uuid,c.repo,c.date,f.filename,c.jiraid,f.added from gitcommit c inner join filechurn f on f.uuid=c.uuid where c.date > '2013-01-01' and c.jiratype='CA'),
gr as (select g.repo,g.filename,count(distinct(jiraid)) as cjid ,sum(g.added) as added,fm.loc as loc
from g inner join filemap fm on fm.repo=g.repo and fm.filename=g.filename
group by g.filename)
select gr.repo,gr.filename,gr.cjid as "#CAs" ,gr.added as "CA LOC churn",gr.loc as LOC,round(gr.added*100/gr.loc) as "% churn",round((1000.0*gr.cjid)/gr.loc,2) as "#defects/KLoc" 
from gr
group by gr.filename
order by "#CAs" desc;
