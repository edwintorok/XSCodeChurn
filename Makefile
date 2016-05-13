#!/usr/bin/make -f
.PHONY: gitlog gitsync login initdb copytables cafromhfxcsv resetdb db qdb fixup clean reallyclean filerepomap deploy test
#Which git repos are in scope
gitrepos:=gitrepos.csv
#Where git repos are synced and intermediary files generated
workingdir:=/local/scratch/philippeg/trunkanalysis
#www params
deploydir:=/var/www/devtest
#targets
filerepomap:=$(workingdir)/filerepomap.csv
filemap:=$(workingdir)/filemap.csv
repolist:=$(shell cut -d, -f3 gitrepos.csv)
#Histograms for individual repos
CAbyMonthQs=$(foreach i,$(repolist),CAStatsByMonth.$(i).png)
queriespng:=$(CAbyMonthQs) churndistribution.png
#Top level reports
queriescsv:=statsbyrepo.csv statsbyfile.csv statsbycomp.csv statsbyteam.csv
querieshtml:=$(foreach i,$(queriescsv),$(subst .csv,.html,$(i)))
queries:=$(queriescsv) $(querieshtml) $(queriespng)

all:gitsync gitlog filerepomap filemap db churndistribution.png fixup qdb deploy
gitsync:
	./gitsync.sh $(workingdir)  < $(gitrepos)
gitlog:
	./gitlog.sh $(workingdir)  < $(gitrepos)
filerepomap:
	./genfilerepomap.sh $(workingdir) < $(gitrepos) > $(filerepomap)
filemap:
	./genfilemap.sh $(workingdir) < $(filerepomap) > $(filemap)
cafromhfxcsv: cafromhfx/Makefile
	make -C cafromhfx
initdb: resetdb
	sqlite3 $(workingdir)/dbfile < schema.sql
login:
	sqlite3 $(workingdir)/dbfile
copytables:
	sqlite3 --separator , $(workingdir)/dbfile ".import  $(workingdir)/commit.git.csv gitcommit"
	sqlite3 --separator , $(workingdir)/dbfile ".import  cafromhfx/cafromhfx.csv CAs"
	sqlite3 --separator , $(workingdir)/dbfile ".import  $(workingdir)/filechurn.git.csv filechurn"
	sqlite3 --separator , $(workingdir)/dbfile ".import  $(workingdir)/chunk.git.csv chunk"
	sqlite3 --separator , $(workingdir)/dbfile ".import  gitrepos.csv repos"
	sqlite3 --separator , $(workingdir)/dbfile ".import  $(workingdir)/filemap.csv filemap"
	sqlite3 --separator , $(workingdir)/dbfile ".import  component2team.csv component2team"
	sqlite3 --separator , $(workingdir)/dbfile ".import  travis-ci.csv travisci"
	sqlite3 --separator , $(workingdir)/dbfile ".import  coveralls.csv coveralls"

resetdb:
	rm -rf $(workingdir)/dbfile
fixup:
	sqlite3 $(workingdir)/dbfile < fixup.sql
db: resetdb initdb copytables
	@echo 'Rebuilding Database...'
qdb: $(queries)
	@echo 'Querying the db...' 
clean: 
	rm -f $(queriescsv) $(querieshtml) $(queriespng)
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
