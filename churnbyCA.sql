-- Filenames changed by CAs
-- with total code churn
-- ranked by number of CAs involved
select filename,count(uuid) as count,sum(churn) as total from filechurn where uuid in 
	(select uuid from commit where jiratype='CA')
group by filename 
order by count desc;
