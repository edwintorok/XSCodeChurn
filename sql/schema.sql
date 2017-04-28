CREATE TABLE gitcommit (
	uuid char(40),
	repo varchar(120),
	author varchar(120),
	date date,
	jiratype varchar(4),
	jiraid integer,
	summary char(80)
);
CREATE TABLE CAs (
jiraid integer
);
CREATE TABLE openCAs (
	team char(120),
	blocker integer,
	critical integer,
	major integer,
	minor integer,
	trivial integer
);
CREATE INDEX commit_uuid ON gitcommit (uuid);
CREATE TABLE filechurn (
	uuid char(40),
	repo varchar(120),
	added integer,
	remvd integer,
	churn integer,
	filename varchar(200),
	extension varchar(30)
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
	name varchar(120)
);
CREATE TABLE component2team(
	comp varchar(120),
	team varchar(120)
);
CREATE TABLE travisci (
	repo varchar(120),
	url varchar(255)
);
CREATE TABLE coveralls (
	repo varchar(120),
	url varchar(255)
);
CREATE TABLE tests(
	jiratype varchar(4),
	jiraid integer,
	xenrt_job integer,
	xenrt_sequence varchar(120),
	tc_id varchar(20),
	tc_variant varchar(120)
);
