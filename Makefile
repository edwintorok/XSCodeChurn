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
remote:=$(call config,'remote')
localdir:=$(call config,'localdir')
#psql generic methods
PSQLPass=export PGPASSWORD=$(password)
ConnectToPSQL=psql --host=$(host) --dbname=$(dbname) --username=$(username)
#targets
filerepomap=$(localdir)/filerepomap.csv
filemap=$(localdir)/filemap.csv
all: initdb gitlog filerepomap filemap copytables
gitsync:
	./gitsync.sh $(remote) $(localdir)  < gitrepos.csv
gitlog:
	./gitlog.sh $(remote) $(localdir)  < gitrepos.csv
filerepomap:
	./genfilerepomap.sh $(localdir) < gitrepos.csv > $(filerepomap)
filemap:
	./genfilemap.sh $(localdir) < $(filerepomap) > $(filemap)
login:
	$(PSQLPass) ; $(ConnectToPSQL)
initdb:
	$(PSQLPass) ; $(ConnectToPSQL) -f schema.sql
copytables:
	$(PSQLPass); $(ConnectToPSQL) -c "\copy commit from $(localdir)/commit.git.csv with CSV;" 
	$(PSQLPass); $(ConnectToPSQL) -c "\copy filechurn from  $(localdir)/filechurn.git.csv with CSV;"
	$(PSQLPass); $(ConnectToPSQL) -c "\copy filemap from $(localdir)/filemap.csv WITH CSV;" 
resetdb:
	$(PSQLPass) ; $(ConnectToPSQL) -f reset.table.sql
clean: resetdb
	rm -f $(localdir)/*.csv
reallyclean: clean
	rm -f $(localdir)/*.log
testsql:
	$(PSQLPass) ; $(ConnectToPSQL) -c "select * from commit order by date desc;"
test: 
	$(PSQLPass);  $(ConnectToPSQL)  -f listrepos.sql
%:
	$(PSQLPass) ; $(ConnectToPSQL)  -f $@.sql > out.txt

