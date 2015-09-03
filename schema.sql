CREATE TABLE commit (
	uuid char(40),
	repo varchar(120),
	author varchar(120),
	date date,
	jiratype varchar(4),
	jiraid integer,
	summary char(80),
	CONSTRAINT pkey PRIMARY KEY(repo,uuid)
);
CREATE TABLE filechurn (
	uuid char(40),
	repo varchar(120),
	added integer,
	remvd integer,
	churn integer,
	filename varchar(120)
);
CREATE TABLE chunk (
	uuid char(40),
	repo varchar(120),
	filename varchar(120),
	context varchar(120)
);
CREATE TABLE filemap (
	repo varchar(120),
	filename varchar(255),
	extension varchar(120),
	loc integer
);
CREATE TABLE compmap (
	repo varchar(120),
	comp varchar(120)
);
CREATE TABLE travisci (
	repo varchar(120),
	url varchar(255)
);
CREATE TABLE coveralls (
	repo varchar(120),
	url varchar(255)
);
