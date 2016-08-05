#See: http://stackoverflow.com/questions/14578676/gnuplot-xdata-time-and-boxes
set terminal png size 1200, 800
set title title
set datafile separator ','
set output outfile
set xdata time
set key left top
set key autotitle columnhead 
set timefmt "%Y-%m"
set format x "%Y-%m"
set xrange [xmin:xmax]
set xtics rotate by -45 offset 0,0
set ylabel "#churn"
set y2label "#CAs"
set y2tics
set y2range [0:*]
set y2tics 1
set ytics nomirror
set autoscale y
set boxwidth 3600*24*30
set style fill solid 1.0
set style line 5 lt rgb "orange-red" lw 2
plot 	infile using 1:3 with boxes lc rgb "green",\
	infile using 1:4 with boxes lc rgb"royalblue",\
	infile using 1:5 with lines ls 5 axes x1y2,\
	"milestones.csv" using 1:2 with impulse lw 2,\
	"milestones.csv" using 1:3:4 with labels rotate left
