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
all: login
gitsync:
	./gitsync.sh $(remote) $(localdir)  < gitrepos.csv
gitlog:
	./gitlog.sh $(remote) $(localdir)  < gitrepos.csv
login:
	$(PSQLPass) ; $(ConnectToPSQL)
initdb:
	$(PSQLPass) ; $(ConnectToPSQL) -f filechurn.table.sql
	$(PSQLPass) ; $(ConnectToPSQL) -f commit.table.sql
resetdb:
	$(PSQLPass) ; $(ConnectToPSQL) -f reset.table.sql
clean:
	rm -f $(localdir)/*.log $(localdir)/*.csv
