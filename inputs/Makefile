.PHONY:
workingdir:=/local/scratch/philippeg/trunk-analysis
specsdir:=$(workingdir)/xenserver-specs
all: components.txt
#frompq.txt is created manually, by inspecting spec files pointed to by .lnk
frompq.txt:
	printf "blktap\nsm\nxen\n" > $@
names.txt:
	grep "^Name:" $(specsdir)/SPECS/*.spec | sed 's/[^ ]*\s*//' | sort | uniq > $@
buildrequires.txt:
	grep "^BuildRequires:" $(specsdir)/SPECS/*.spec | sed 's/[^ ]*\s*//' | sort | uniq > $@
components.txt:  frompq.txt names.txt buildrequires.txt
	cat $^ | sort | uniq > $@
clean:
	rm components.txt frompq.txt names.txt buildrequires.txt

