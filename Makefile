#!/usr/bin/make -f
.SECONDARY:
.PHONY: gitlog gitsyncXformer gitsyncMirror gitsync filerepomap filemap login initdb copytables cafromhfxcsv fetchOpenDefects resetdb db qdb fixup setfiletype clean reallyclean deploy test
VPATH = sql/ gnuplot/ inputs/
#sqlite binary, requires at lease 3.8.3
sqlitebin:=/local/scratch/philippeg/sqlite-tools-linux-x86-3180000/sqlite3
#Which transformered repos are in scope
specs:=inputs/specs.csv
#Which mirrors are in scope
mirrors:=inputs/mirrorRepos.csv
#Where git repos are synced and intermediary files generated
workingdir:=/local/scratch/philippeg/trunk-analysis
specsdir:=$(workingdir)/xenserver-specs
#Dates
beginDate:='2017-04-01'
endDate:='2017-07-01'
#www params
deploydir:=~/public_html/staging/
#targets
filerepomap:=$(workingdir)/filerepomap.csv
filemap:=$(workingdir)/filemap.csv
repolist:=$(shell cut -d, -f2 $(specs))
#Histograms for individual repos
CAbyMonthQs=$(foreach i,$(repolist),CAStatsByMonth.$(i).png)
CAStatsByTeam:= CAStatsByTeam.xs-ring3.png
#Top level reports
pngs:=$(CAbyMonthQs) $(CAStatsByTeam)
queries:=statsbyrepo.sql statsbyfile.sql statsbycomp.sql statsbyteam.sql OpenDefectDensity.sql churnByrepoBydate.sql locbyrepo.sql
htmls:=$(subst .sql,.html,$(queries))
csvs:=$(subst .sql,.csv,$(queries))
#targets:= $(htmls) $(csvs)
targets:= $(htmls) $(csvs) $(pngs)
all: gitsync gitlog filerepomap filemap cafromhfxcsv fetchOpenDefects db fixup setfiletype qdb deploy
gitsync: gitsyncXformer gitsyncMirror
gitsyncXformer:
	./gitsync-xformer.sh $(specsdir)  < $(specs)
gitsyncMirror:
	./gitsync.sh $(specsdir)  < $(mirrors)
allrepos.csv:
	cat $(specs) $(mirrors) > $@
gitlog:allrepos.csv
	./gitlog.sh $(workingdir)  $(specsdir) < $<
filerepomap:allrepos.csv
	./genfilerepomap.sh $(specsdir) < $< > $(filerepomap)
filemap:
	./genfilemap.sh $(specsdir) < $(filerepomap)  > $(filemap)
ca.csv: $(workingdir)/commit.git.csv
	sed -n 's/^[^,]*,[^,]*,[^,]*,[^,]*,CA,\([^,]*\).*/CA-\1/p' $< | sort | uniq > $@	
tests.csv: ca.csv
	./fetchTCsFromCAs.sh < $< > $@
	sed -i 's/^CA-/CA,/' $@
cafromhfxcsv: cafromhfx/Makefile
	make -C cafromhfx
fetchOpenDefects: fetchOpenDefects/Makefile
	make -C fetchOpenDefects
initdb: resetdb
	$(sqlitebin) $(workingdir)/dbfile < sql/schema.sql
login:
	$(sqlitebin) $(workingdir)/dbfile
copytables:allrepos.csv
	$(sqlitebin) --separator , $(workingdir)/dbfile ".import  $(workingdir)/commit.git.csv gitcommit"
	$(sqlitebin) --separator , $(workingdir)/dbfile ".import  cafromhfx/cafromhfx.csv CAs"
	$(sqlitebin) --separator , $(workingdir)/dbfile ".import  fetchOpenDefects/opendefects.csv openCAs"
	$(sqlitebin) --separator , $(workingdir)/dbfile ".import  $(workingdir)/filechurn.git.csv filechurn"
	$(sqlitebin) --separator , $(workingdir)/dbfile ".import  $(workingdir)/chunk.git.csv chunk"
	$(sqlitebin) --separator , $(workingdir)/dbfile ".import  $< repos"
	$(sqlitebin) --separator , $(workingdir)/dbfile ".import  $(workingdir)/filemap.csv filemap"
	$(sqlitebin) --separator , $(workingdir)/dbfile "UPDATE filemap SET type=1;"
	$(sqlitebin) --separator , $(workingdir)/dbfile ".import  inputs/component2team.csv component2team"
	$(sqlitebin) --separator , $(workingdir)/dbfile ".import  inputs/travis-ci.csv travisci"
	$(sqlitebin) --separator , $(workingdir)/dbfile ".import  inputs/coveralls.csv coveralls"
#	$(sqlitebin) --separator , $(workingdir)/dbfile ".import  tests.csv tests"

resetdb:
	rm -rf $(workingdir)/dbfile
fixup:
	$(sqlitebin) $(workingdir)/dbfile < sql/fixup.sql
setfiletype:
	$(sqlitebin) $(workingdir)/dbfile < sql/setfiletype.sql
db: resetdb initdb copytables
	@echo 'Rebuilding Database...'
qdb: $(targets)
	@echo 'Querying the db...' 
clean: 
	rm -f *.sql *.csv *.png *.html
#	make -C cafromhfx clean
#	make -C fetchOpenDefects clean
reallyclean: clean resetdb
	rm -f $(workingdir)/*.log
	rm -f $(workingdir)/*.csv
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
churnByrepoBydate.sql: churnByrepoBydate.m4
	m4 -D m4BeginDate=$(beginDate)  -D m4EndDate=$(endDate) $< > $@ 
	
%.csv: %.sql
	$(sqlitebin) -init config/sqlite.csv.init $(workingdir)/dbfile < $< > $@
%.html: %.sql
	echo '<link rel="stylesheet" type="text/css" href="index.css">' > $@
	echo '<table border="1">' >> $@
	date >> $@
	$(sqlitebin) -init config/sqlite.html.init  $(workingdir)/dbfile < $< >> $@
	echo '</table>' >> $@
deploy:
	cp *.csv *.html html/* *.png $(deploydir) 
test:
	$(sqlitebin) --separator , $(workingdir)/dbfile "UPDATE filemap SET type=1;"
sql/churnByrepoBydate.csv: sql/churnByrepoBydate.m4
	m4 -D m4BeginDate='2017-04-01'  -D m4EndDate='2017-07-01'  sql/churnByrepoBydate.m4 >  sql/churnByrepoBydate.sql
	$(sqlitebin) -init config/sqlite.csv.init $(workingdir)/dbfile <   sql/churnByrepoBydate.sql > $@
