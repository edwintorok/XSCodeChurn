#!/usr/bin/make -f
.PHONY: login gitlog initdb copytables resetdb clean reallyclean filerepomap
SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
configFile:=$(SELF_DIR)/.config.trunk
#PostgreSQL server params, read from .config file
config=$(lastword $(shell grep $(1) $(configFile)))
host:=$(call config,'host')
dbname:=$(call config,'dbname')
username:=$(call config,'username')
password:=$(call config,'password')
#git param
workingdir:=$(call config,'workingdir')
repos=$(workingdir)/repos.csv
gitrepos:=$(workingdir)/gitrepos.csv
#www params
deploydir:=/var/www/devtest
#targets
filerepomap=$(workingdir)/filerepomap.csv
filemap=$(workingdir)/filemap.csv
queries=CAbyFiles.sql.csv chunkbyCA.sql.csv chunk.sql.csv churn.sql.csv inventory.sql.csv listrepos.sql.csv stats.sql.csv churnbyrepo.sql.csv
#queries+=CAbyFiles.html chunkbyCA.html chunk.html churn.html inventory.html listrepos.html stats.html churnbyrepo.html
#all: $(repos)  $(gitrepos) gitsync gitlog filerepomap filemap db qdb 
all: $(repos)  $(gitrepos)
$(repos):
	grep -v '^#' gitrepos.csv > $@
#	./genrepo2componentmap.sh $(workingdir) > $(repos)
$(gitrepos): $(repos)
	cp gitrepos.csv $@
#	grep '.git$$' $< | sed 's/http:/git:/' > $@
gitsync:
	./gitsync.sh $(workingdir)  < $(gitrepos)
gitlog:
	./gitlog.sh $(workingdir)  < $(gitrepos)
filerepomap:
	./genfilerepomap.sh $(workingdir) < $(gitrepos) > $(filerepomap)
filemap:
	./genfilemap.sh $(workingdir) < $(filerepomap) > $(filemap)
login:
	$(PSQL)
initdb: resetdb
	sqlite3 $(workingdir)/dbfile < schema.sql
copytables:
	sqlite3 --separator , $(workingdir)/dbfile ".import  $(workingdir)/commit.git.csv gitcommit"
	sqlite3 --separator , $(workingdir)/dbfile ".import  $(workingdir)/filechurn.git.csv filechurn"
	sqlite3 --separator , $(workingdir)/dbfile ".import  $(workingdir)/chunk.git.csv chunk"
	sqlite3 --separator , $(workingdir)/dbfile ".import  $(workingdir)/repos.csv repos"
	sqlite3 --separator , $(workingdir)/dbfile ".import  $(workingdir)/filemap.csv filemap"
	sqlite3 --separator , $(workingdir)/dbfile ".import  $(workingdir)/travis-ci.csv travisci"
	sqlite3 --separator , $(workingdir)/dbfile ".import  $(workingdir)/coveralls.csv coveralls"

resetdb:
	rm -rf $(workingdir)/dbfile
db: resetdb initdb copytables
	@echo 'Rebuilding Database...'
qdb: $(queries)
	@echo 'Querying the db...' 
clean: 
	rm -f $(queries)
reallyclean: clean resetdb
	rm -f $(workingdir)/*.log
test: 
	@echo $(queries)
#%.sql.csv: %.sql
#	$(PSQL) --field-separator="," --no-align --tuples-only -f $< -o $@
%.sql.csv: %.sql
	sqlite3 --separator , $(workingdir)/dbfile < $<
%.html: %.sql
	$(PSQL)  -H -f $< -o $@
	sed -i '1s;^;<link rel="stylesheet" type="text/css" href="psql.css">\n;' $@
deploy:
	cp *.csv *.html *.css $(deploydir) 
