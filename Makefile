#!/usr/bin/make -f
.PHONY: gitlog initdb copytables resetdb clean reallyclean filerepomap test
SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
configFile:=$(SELF_DIR)/.config.trunk
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
repolist=$(shell cut -d, -f3 gitrepos.csv)
CAbyMonthQs=$(foreach i,$(repolist),CAStatsByMonth.$(i).png)
queries=statsbyrepo.csv
#queries=CAStatsByDay.csv CAStatsByMonth.csv
#queries=CAbyFiles.csv chunkbyCA.csv chunk.csv churn.csv listrepos.csv churnbyrepo.csv
#queries+=CAbyFiles.html chunkbyCA.html chunk.html churn.html listrepos.html churnbyrepo.html
#queries+=inventory.html inventory.csv stats.csv stats.html
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
initdb: resetdb
	sqlite3 $(workingdir)/dbfile < schema.sql
login:
	sqlite3 $(workingdir)/dbfile
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
fixup:
	sqlite3 $(workingdir)/dbfile < fixup.sql
db: resetdb initdb copytables
	@echo 'Rebuilding Database...'
qdb: $(queries)
	@echo 'Querying the db...' 
clean: 
	rm -f $(queries)
reallyclean: clean resetdb
	rm -f $(workingdir)/*.log
CAStatsByMonth.%.png: CAStatsByMonth.%.csv
	gnuplot -e "xmin='2013-01';xmax='2016-04';title='$@';outfile='$@';infile='$<'" CAStatsByMonth.gnuplot
CAStatsByDay.%.png: CAStatsByDay.%.csv
	gnuplot -e "xmin='2013-01-01';xmax='2016-04-30';title='$@';outfile='$@';infile='$<'" CAStatsByDay.gnuplot
churndistribution.png: churndistribution.csv
	gnuplot -e "title='$@';outfile='$@';infile='$<'" churndistribution.gnuplot
CAStatsByMonth.%.sql: CAStatsByMonth.sql.m4
	m4 -D repoVar=$* $< > $@
CAStatsByDay.%.sql: CAStatsByDay.sql.m4
	m4 -D repoVar=$* $< > $@
%.csv: %.sql
	sqlite3 -init sqlite.csv.init $(workingdir)/dbfile < $< > $@
%.html: %.sql
	echo '<link rel="stylesheet" type="text/css" href="index.css">' > $@
	echo '<table border="1">' >> $@
	sqlite3 -init sqlite.html.init  $(workingdir)/dbfile < $< >> $@
	echo '</table>' >> $@
deploy:
	cp *.csv *.html *.css *.png $(deploydir) 
test: $(CAbyMonthQs)
