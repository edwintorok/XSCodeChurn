CREATE TABLE gitcommit (
	uuid char(40),
	repo varchar(120),
	author varchar(120),
	date date,
	jiratype varchar(4),
	jiraid integer,
	summary char(80)
);
CREATE INDEX commit_uuid ON gitcommit (uuid);
CREATE TABLE filechurn (
	uuid char(40),
	repo varchar(120),
	added integer,
	remvd integer,
	churn integer,
	filename varchar(200)
);
CREATE TABLE chunk (
	uuid char(40),
	repo varchar(120),
	filename varchar(200),
	context varchar(80)
);
CREATE INDEX chunk_uuid ON chunk (uuid);
CREATE TABLE filemap (
	repo varchar(120),
	filename varchar(200),
	extension varchar(30),
	loc integer
);
CREATE TABLE repos (
	comp varchar(120),
	url varchar(255),
	name varchar(120)
);
CREATE TABLE travisci (
	repo varchar(120),
	url varchar(255)
);
CREATE TABLE coveralls (
	repo varchar(120),
	url varchar(255)
);
