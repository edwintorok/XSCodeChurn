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
gitrepos:=$(workingdir)/gitrepos.csv
#psql generic methods
PSQLPass=export PGPASSWORD=$(password)
PSQL=$(PSQLPass);psql --host=$(host) --dbname=$(dbname) --username=$(username)
#targets
filerepomap=$(workingdir)/filerepomap.csv
filemap=$(workingdir)/filemap.csv
repos=$(workingdir)/repos.csv
travis-ci=$(workingdir)/travis-ci.csv
coveralls=$(workingdir)/coveralls.csv
queries=CAbyFiles.html chunkbyCA.html chunk.html churn.html inventory.html listrepos.html stats.html
queries+=CAbyFiles.sql.csv chunkbyCA.sql.csv chunk.sql.csv churn.sql.csv inventory.sql.csv listrepos.sql.csv stats.sql.csv
all: initdb $(repos)  $(gitrepos) $(travis-ci) $(coveralls) gitsync gitlog filerepomap filemap copytables
$(repos):
	grep -v '^#' gitrepos.csv > $@
#	./genrepo2componentmap.sh $(workingdir) > $(repos)
$(gitrepos): $(repos)
	cp gitrepos.csv $@
#	grep '.git$$' $< | sed 's/http:/git:/' > $@
$(travis-ci) $(coveralls):
	wget http://dart.uk.xensource.com/devtest/$(@F) -O $@
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
initdb:
	$(PSQL) -f schema.sql
copytables:
	$(PSQL) -c "\copy commit from $(workingdir)/commit.git.csv with CSV;" 
	$(PSQL) -c "\copy filechurn from  $(workingdir)/filechurn.git.csv with CSV;"
	$(PSQL) -c "\copy chunk from $(workingdir)/chunk.git.csv WITH CSV;" 
	$(PSQL) -c "\copy filemap from $(filemap) WITH CSV;" 
	$(PSQL) -c "\copy repos from $(repos) WITH CSV;" 
	$(PSQL) -c "\copy travisci from $(travis-ci) WITH CSV;" 
	$(PSQL) -c "\copy coveralls from $(coveralls) WITH CSV;" 
resetdb:
	$(PSQL) -f reset.table.sql
db: resetdb initdb copytables
	@echo 'Rebuilding Database...'
qdb: $(queries)
	@echo 'Querying the db...' 
clean: resetdb
	rm -f $(workingdir)/*.csv *.html
reallyclean: clean
	rm -f $(workingdir)/*.log
test: 
	echo $(queries)
%.sql.csv: %.sql
	$(PSQL) --field-separator="," --no-align --tuples-only -f $< -o $@
%.html: %.sql
	$(PSQL)  -H -f $< -o $@
	sed -i '1s;^;<link rel="stylesheet" type="text/css" href="psql.css">\n;' $@

