#!/usr/bin/make -f
# philippeg jan2017
#
.PHONY: login initdb resetdb import copytables test
configFile:=psqlconfig/.config
#jira server params, read from .config file
config=$(lastword $(shell grep $(1) $(configFile)))
host:=$(call config,'host')
dbname:=$(call config,'dbname')
username:=$(call config,'username')
password:=$(call config,'password')
#psql generic methods
setJiraPass=export PGPASSWORD=$(password)
ConnectToJira=psql --host=$(host) --dbname=$(dbname) --username=$(username)
workingdir:=/local/scratch/philippeg/trunkanalysis
gitrepos:=inputs/gitrepos.csv
###############################################################################################
all: resetdb initdb copytables
login:
	$(setJiraPass) ; $(ConnectToJira)
initdb:
	$(setJiraPass) ; $(ConnectToJira) -f sql/schema.sql
resetdb:
	$(setJiraPass) ; $(ConnectToJira) -f sql/droptables.sql
import:
	$(setJiraPass) ; $(ConnectToJira) -f dbfiledump.sql
copytables:
	$(setJiraPass) ; cat $(workingdir)/commit.git.csv | $(ConnectToJira) -c "COPY gitcommit FROM stdin delimiter ',' csv;"
	$(setJiraPass) ; cat $(workingdir)/chunk.git.csv | $(ConnectToJira) -c "COPY chunk FROM stdin delimiter ',' csv;"
	$(setJiraPass) ; cat tests.csv | $(ConnectToJira) -c "COPY tests FROM stdin delimiter ',' csv;"
test:
	 $(setJiraPass) ; $(ConnectToJira) -A --variable=FILENAME="Agent/Collectors/XenCollectorBase.cs" -f sql/psql-testsByFile.sql
