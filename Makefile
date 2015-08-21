#!/usr/bin/make -f
.PHONY: login
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
all: initdb gitlog copytables
gitsync:
	./gitsync.sh $(remote) $(localdir)  < gitrepos.csv
gitlog:
	./gitlog.sh $(remote) $(localdir)  < gitrepos.csv
login:
	$(PSQLPass) ; $(ConnectToPSQL)
initdb:
	$(PSQLPass) ; $(ConnectToPSQL) -f filechurn.createtable.sql
	$(PSQLPass) ; $(ConnectToPSQL) -f commit.createtable.sql
copytables:
	echo "\copy commit from $(localdir)/commit.xen-api.git.csv WITH CSV;" > $(localdir)/tmp.sql
	echo "\copy filechurn from $(localdir)/filechurn.xen-api.git.csv WITH CSV;" >> $(localdir)/tmp.sql
	$(PSQLPass) ; $(ConnectToPSQL) -f $(localdir)/tmp.sql
resetdb:
	$(PSQLPass) ; $(ConnectToPSQL) -f reset.table.sql
clean: resetdb
	rm -f $(localdir)/*.csv
reallyclean:
	rm -f $(localdir)/*.log
