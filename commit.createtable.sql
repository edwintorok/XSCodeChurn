CREATE TABLE commit (
	uuid char(40),
	author varchar(60),
	date date,
	jiratype varchar(4),
	jiraid integer,
	summary char(80),
	PRIMARY KEY(uuid)
);
