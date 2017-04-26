-- repos and loc ordered alphabetically
.print <caption>LOC by git repos ranked alphabetically</caption>
select repo,sum(loc) as sumloc from filemap group by repo
order by repo asc;
