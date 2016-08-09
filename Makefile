#!/usr/bin/make -f
.SECONDARY:
.PHONY: gitlog gitsync login initdb copytables cafromhfxcsv fetchOpenDefects resetdb db qdb fixup clean reallyclean deploy test
VPATH = sql/ gnuplot/ inputs/
#Which git repos are in scope
gitrepos:=inputs/gitrepos.csv
#Where git repos are synced and intermediary files generated
workingdir:=/local/scratch/philippeg/trunkanalysis
#www params
deploydir:=/var/www/devtest
#targets
filerepomap:=$(workingdir)/filerepomap.csv
filemap:=$(workingdir)/filemap.csv
repolist:=$(shell cut -d, -f3 $(gitrepos))
#Histograms for individual repos
CAbyMonthQs=$(foreach i,$(repolist),CAStatsByMonth.$(i).png)
CAStatsByTeam:= CAStatsByTeam.xs-ring3.png
#Top level reports
pngs:=$(CAbyMonthQs) $(CAStatsByTeam) churndistribution.png
htmls:=statsbyrepo.html statsbyfile.html statsbycomp.html statsbyteam.html
targets:= $(htmls) $(pngs)
all: gitsync gitlog $(filerepomap) $(filemap) cafromhfxcsv fetchOpenDefects db churndistribution.png fixup qdb deploy
gitsync:
	./gitsync.sh $(workingdir)  < $(gitrepos)
gitlog:
	./gitlog.sh $(workingdir)  < $(gitrepos)
$(filerepomap):
	./genfilerepomap.sh $(workingdir) < $(gitrepos) > $@
$(filemap): $(filerepomap)
	./genfilemap.sh $(workingdir) < $< > $@
cafromhfxcsv: cafromhfx/Makefile
	make -C cafromhfx
fetchOpenDefects: fetchOpenDefects/Makefile
	make -C fetchOpenDefects
initdb: resetdb
	sqlite3 $(workingdir)/dbfile < sql/schema.sql
login:
	sqlite3 $(workingdir)/dbfile
copytables:
	sqlite3 --separator , $(workingdir)/dbfile ".import  $(workingdir)/commit.git.csv gitcommit"
	sqlite3 --separator , $(workingdir)/dbfile ".import  cafromhfx/cafromhfx.csv CAs"
	sqlite3 --separator , $(workingdir)/dbfile ".import  fetchOpenDefects/opendefects.csv openCAs"
	sqlite3 --separator , $(workingdir)/dbfile ".import  $(workingdir)/filechurn.git.csv filechurn"
	sqlite3 --separator , $(workingdir)/dbfile ".import  $(workingdir)/chunk.git.csv chunk"
	sqlite3 --separator , $(workingdir)/dbfile ".import  $(gitrepos) repos"
	sqlite3 --separator , $(workingdir)/dbfile ".import  $(workingdir)/filemap.csv filemap"
	sqlite3 --separator , $(workingdir)/dbfile ".import  inputs/component2team.csv component2team"
	sqlite3 --separator , $(workingdir)/dbfile ".import  inputs/travis-ci.csv travisci"
	sqlite3 --separator , $(workingdir)/dbfile ".import  inputs/coveralls.csv coveralls"

resetdb:
	rm -rf $(workingdir)/dbfile
fixup:
	sqlite3 $(workingdir)/dbfile < sql/fixup.sql
db: resetdb initdb copytables
	@echo 'Rebuilding Database...'
qdb: $(targets)
	@echo 'Querying the db...' 
clean: 
	rm -f *.sql *.csv *.png *.html
	make -C cafromhfx clean
	make -C fetchOpenDefects clean
reallyclean: clean resetdb
	rm -f $(workingdir)/*.log
CAStatsByTeam.%.png: CAStatsByTeam.%.csv
	gnuplot -e "xmin='2013-01';xmax='2016-07';title='$@';outfile='$@';infile='$<';milestones='inputs/milestones.csv'" gnuplot/CAStatsByTeam.gnuplot
CAStatsByMonth.%.png: CAStatsByMonth.%.csv
	gnuplot -e "xmin='2013-01';xmax='2016-05';title='$@';outfile='$@';infile='$<'" gnuplot/CAStatsByMonth.gnuplot
CAStatsByDay.%.png: CAStatsByDay.%.csv
	gnuplot -e "xmin='2013-01-01';xmax='2016-05-30';title='$@';outfile='$@';infile='$<'" gnuplot/CAStatsByDay.gnuplot
churndistribution.png: churndistribution.csv
	gnuplot -e "title='$@';outfile='$@';infile='$<'" gnuplot/churndistribution.gnuplot
CAStatsByMonth.%.sql: CAStatsByMonth.sql.m4
	m4 -D repoVar=$* $< > $@
CAStatsByDay.%.sql: CAStatsByDay.sql.m4
	m4 -D repoVar=$* $< > $@
CAStatsByTeam.%.sql: CAStatsByTeam.sql.m4
	m4 -D teamVAR=$* $< > $@
%.csv: %.sql
	sqlite3 -init config/sqlite.csv.init $(workingdir)/dbfile < $< > $@
%.html: %.sql
	echo '<link rel="stylesheet" type="text/css" href="index.css">' > $@
	echo '<table border="1">' >> $@
	sqlite3 -init config/sqlite.html.init  $(workingdir)/dbfile < $< >> $@
	echo '</table>' >> $@
deploy:
	cp *.csv *.html html/* *.png $(deploydir) 
test: $(pngs)
