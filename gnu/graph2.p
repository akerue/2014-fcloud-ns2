set title "Task 2-1"
set xlabel "ms "
set ylabel "Window"
set xrange [0:200]
set yrange [0:70]
set nomultiplot
#set size 0.5, 0.5
#set origin 0.0, 0.5

plot "output/plot2-0.log" using 1:7 title 'Window size of tcp0' with linespoints , \
    "output/plot2-1.log" using 1:7 title 'Window size of tcp1' with linespoints 
   
#set tmargin 0
#set bmargin 0
   
set terminal pdf
set output "output/Task2-2.pdf"
replot
set terminal x11
replot
