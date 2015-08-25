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
filelocmap=$(localdir)/filelocmap.csv
all: initdb gitlog $(filerepomap) copytables
gitsync:
	./gitsync.sh $(remote) $(localdir)  < gitrepos.csv
gitlog:
	./gitlog.sh $(remote) $(localdir)  < gitrepos.csv
filerepomap:
	./genfilerepomap.sh $(localdir) < gitrepos.csv > $(filerepomap)
filelocmap:
	./genfilelocmap.sh $(localdir) < $(filerepomap) > $(filelocmap)
login:
	$(PSQLPass) ; $(ConnectToPSQL)
initdb:
	$(PSQLPass) ; $(ConnectToPSQL) -f filechurn.createtable.sql
	$(PSQLPass) ; $(ConnectToPSQL) -f commit.createtable.sql
copytables:
	$(PSQLPass); ./gitcopytables.sh $(localdir) $(host) $(dbname) $(username) < gitrepos.csv
resetdb:
	$(PSQLPass) ; $(ConnectToPSQL) -f reset.table.sql
clean: resetdb
	rm -f $(localdir)/*.csv
reallyclean:
	rm -f $(localdir)/*.log
testsql:
	$(PSQLPass) ; $(ConnectToPSQL) -c "select * from commit order by date desc;"
test: filelocmap

%:
	$(PSQLPass) ; $(ConnectToPSQL)  -f $@.sql > out.txt

