#!/usr/bin/make -f
.PHONY: login gitlog initdb copytables resetdb clean reallyclean filerepomap
SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
configFile:=$(SELF_DIR)/.config
#PostgreSQL server params, read from .config file
config=$(lastword $(shell grep $(1) $(configFile)))
host:=$(call config,'host')
dbname:=$(call config,'dbname')
username:=$(call config,'username')
password:=$(call config,'password')
#git param
workingdir:=$(call config,'workingdir')
gitrepolist:=gitrepos.csv
#psql generic methods
PSQLPass=export PGPASSWORD=$(password)
PSQL=$(PSQLPass);psql --host=$(host) --dbname=$(dbname) --username=$(username)
#targets
filerepomap=$(workingdir)/filerepomap.csv
filemap=$(workingdir)/filemap.csv
all: initdb gitlog filerepomap filemap copytables
gitsync:
	./gitsync.sh $(workingdir)  < $(gitrepolist)
gitlog:
	./gitlog.sh $(workingdir)  < $(gitrepolist)
filerepomap:
	./genfilerepomap.sh $(workingdir) < $(gitrepolist) > $(filerepomap)
filemap:
	./genfilemap.sh $(workingdir) < $(filerepomap) > $(filemap)
login:
	$(PSQL)
initdb:
	$(PSQL) -f schema.sql
copytables:
	$(PSQL) -c "\copy commit from $(workingdir)/commit.git.csv with CSV;" 
	$(PSQL) -c "\copy filechurn from  $(workingdir)/filechurn.git.csv with CSV;"
	$(PSQL) -c "\copy chunk from $(workingdir)/chunk.git.csv WITH CSV;" 
	$(PSQL) -c "\copy filemap from $(workingdir)/filemap.csv WITH CSV;" 
resetdb:
	$(PSQL) -f reset.table.sql
clean: resetdb
	rm -f $(workingdir)/*.csv *.html
reallyclean: clean
	rm -f $(workingdir)/*.log
test:
	$(PSQL) -c "select * from commit order by date desc;"
%.html: %.sql
	$(PSQL)  -H -f $< -o $@
	sed -i '1s;^;<link rel="stylesheet" type="text/css" href="psql.css">\n;' $@

