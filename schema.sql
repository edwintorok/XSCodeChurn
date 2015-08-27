CREATE TABLE commit (
	uuid char(40),
	author varchar(60),
	date date,
	jiratype varchar(4),
	jiraid integer,
	summary char(80),
	PRIMARY KEY(uuid)
);
CREATE TABLE filechurn (
	uuid char(40),
	added integer,
	remvd integer,
	churn integer,
	filename varchar(120)
);
CREATE TABLE filemap (
	repo varchar(60),
	filename varchar(120),
	extension varchar(60),
	loc integer
);
