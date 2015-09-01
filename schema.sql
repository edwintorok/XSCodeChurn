CREATE TABLE commit (
	uuid char(40),
	repo varchar(60),
	author varchar(60),
	date date,
	jiratype varchar(4),
	jiraid integer,
	summary char(80),
	CONSTRAINT pkey PRIMARY KEY(repo,uuid)
);
CREATE TABLE filechurn (
	uuid char(40),
	repo varchar(60),
	added integer,
	remvd integer,
	churn integer,
	filename varchar(120)
);
CREATE TABLE chunk (
	uuid char(40),
	repo varchar(60),
	filename varchar(120),
	context varchar(120)
);
CREATE TABLE filemap (
	repo varchar(60),
	filename varchar(255),
	extension varchar(60),
	loc integer
);
