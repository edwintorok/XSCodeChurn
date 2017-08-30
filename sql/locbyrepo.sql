-- repos and loc ordered alphabetically
.print <caption>LOC by git repos ranked alphabetically</caption>
select repo,sum(loc) as sumloc from filemap where type=1 group by repo
order by repo asc;
