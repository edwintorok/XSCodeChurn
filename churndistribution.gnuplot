#See: http://stackoverflow.com/questions/13934163/x-range-for-non-numerical-data-in-gnuplot
set terminal png size 1200, 800
set title 'Distribution of churn size per file per commit'
set datafile separator ','
set output outfile
set key left top
set xtics rotate by -45 offset 0,0
set xlabel "churn ranges"
set ylabel "# commits"
set style fill solid 1.0
plot infile using (column(0)):2:xtic(1) ti col with boxes lc rgb"royalblue"
