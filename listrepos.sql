-- Filenames changed by CAs
-- with total code churn
-- ranked by number of CAs involved
select  repo from commit
group by repo
order by repo asc;
