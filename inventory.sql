-- list all repos and their dev test attributes
\pset title 'repo inventory'
select  distinct repos.name,count(filemap.filename) as "#files", sum(filemap.loc) as "#lines code",travisci.url as "travis url",coveralls.url as "coveralls url"
from repos
full outer join travisci
on  repos.name=travisci.repo
full outer join coveralls  
on  repos.name=coveralls.repo
full outer join filemap
on  repos.name=filemap.repo
group by   repos.name,travisci.url,coveralls.url
order by  repos.name asc;
