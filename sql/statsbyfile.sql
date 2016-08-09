-- files ranked by #CA
.print <caption>Defect density and churn by files ranked by #CAs, since 2013</caption>
with
g as (select c.uuid,c.repo,c.date,f.filename,c.jiraid,f.added from gitcommit c inner join filechurn f on f.uuid=c.uuid where c.date > '2013-01-01' and c.jiratype='CA'),
-- join g with CAs, to get LCM CAs
g2 as (select g.uuid,g.date,g.repo,g.filename,g.jiraid,g.added,CAs.jiraid as lcmjiraid
from g left outer join CAs on g.jiraid=CAs.jiraid),
--group by filename
gr as (select g2.repo,g2.filename,count(distinct(g2.jiraid)) as cjid,count(distinct(g2.lcmjiraid)) as lcmcjid ,sum(g2.added) as added,fm.loc as loc
from g2 inner join filemap fm on fm.repo=g2.repo and fm.filename=g2.filename
group by g2.filename)
--
select gr.repo,gr.filename,gr.cjid as "#CAs" ,gr.lcmcjid as "#HFXs",gr.added as "CA LOC churn",gr.loc as LOC,round(gr.added*100/gr.loc) as "% churn",round((1000.0*gr.cjid)/gr.loc,2) as "#defects/KLoc",round((1000.0*gr.lcmcjid)/gr.loc,2) as "#HFXs/KLoc"
from gr
group by gr.filename
order by "#CAs" desc;
