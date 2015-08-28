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
ConnectToPSQL=psql --host=$(host) --dbname=$(dbname) --username=$(username)
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
	$(PSQLPass) ; $(ConnectToPSQL)
initdb:
	$(PSQLPass) ; $(ConnectToPSQL) -f schema.sql
copytables:
	$(PSQLPass); $(ConnectToPSQL) -c "\copy commit from $(workingdir)/commit.git.csv with CSV;" 
	$(PSQLPass); $(ConnectToPSQL) -c "\copy filechurn from  $(workingdir)/filechurn.git.csv with CSV;"
	$(PSQLPass); $(ConnectToPSQL) -c "\copy filemap from $(workingdir)/filemap.csv WITH CSV;" 
resetdb:
	$(PSQLPass) ; $(ConnectToPSQL) -f reset.table.sql
clean: resetdb
	rm -f $(workingdir)/*.csv
reallyclean: clean
	rm -f $(workingdir)/*.log
testsql:
	$(PSQLPass) ; $(ConnectToPSQL) -c "select * from commit order by date desc;"
test: 
	$(PSQLPass);  $(ConnectToPSQL)  -f listrepos.sql
%:
	$(PSQLPass) ; $(ConnectToPSQL)  -f $@.sql > out.txt

