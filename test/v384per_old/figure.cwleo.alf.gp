#!/usr/bin/gnuplot
#
#
# set terminal postscript landscape enhanced mono dashed lw 0.5  "Times-Roman" 12  #'Helvetica' 10
# set terminal postscript eps enhanced color dashed lw 1.0 size 3.50,5.70 "Times-Roman" 16 #'Helvetica' 10
# set terminal postscript eps enhanced color dashed lw 1.0 size 4.87,2.20 "Times-Roman" 16 #'Helvetica' 10
# set output 'figure.cwleo.alf.var.eps'


vlsr=-26.5
vel1=-45.+vlsr
vel2=+45.+vlsr

# set ylabel "Flux Density (Jy/beam)"
set ylabel "T_A^{\*} (K)"
set xlabel "V_{LSR} (km/s)"
set format y "%.1f"
set format x "%.0f"
set xtics  30.
set mxtics 3
set ytics  0.1
set mytics 5

fileprofile='profile.cwleo.max.alf'
fileprofile1='profile.cwleo.mean.alf'
#fileprofile1='empty.dat'
fileprofile2='profile.cwleo.min.alf'
fileprofile3='empty.dat'
# fileprofile3='profile.cwleo.max.alf'


set multiplot layout 4,2 \
             margins 0.10,0.98,0.1,0.98 \
             spacing 0.12,0.06

f1a=-0.1
f1b=0.4

# based on work on observations ATC of CO 2-1 in Egg nebula
# conversion=1./0.63


# order panels
order = " 4 8 3 7 2 6 1 5"


# molecule AlF   transition=    3 frequency=    98.9267 GHz   hpbw=   24.9 (arcsec)  offset=    0.0                                                                                                                                                             
# molecule AlF   transition=    4 frequency=   131.8988 GHz   hpbw=   18.6 (arcsec)  offset=    0.0                                                                                                                                                             
# molecule AlF   transition=    5 frequency=   164.8679 GHz   hpbw=   14.9 (arcsec)  offset=    0.0                                                                                                                                                             
# molecule AlF   transition=    6 frequency=   197.8330 GHz   hpbw=   12.4 (arcsec)  offset=    0.0                                                                                                                                                             
# molecule AlF   transition=    7 frequency=   230.7940 GHz   hpbw=   10.6 (arcsec)  offset=    0.0                                                                                                                                                             
# molecule AlF   transition=    8 frequency=   263.7493 GHz   hpbw=    9.3 (arcsec)  offset=    0.0                                                                                                                                                             
# molecule AlF   transition=    9 frequency=   296.6989 GHz   hpbw=    8.3 (arcsec)  offset=    0.0                                                                                                                                                             
# molecule AlF   transition=   10 frequency=   329.6416 GHz   hpbw=    7.5 (arcsec)  offset=    0.0                                                                                                                                                             
freqGHz= " 98.9267 131.8988 164.8679 197.8330 230.7940 263.7493 296.6989 329.6416"
wavemm=  "  3.       2.3      1.8      1.5      1.3      1.1      1.       0.9   "
feff=    "  0.95     0.93     0.93     0.91     0.91     0.88     0.88     0.84  "
beff=    "  0.76     0.71     0.66     0.59     0.52     0.46     0.45     0.38  "
receiver="  ABCD     ABCD     ABCD     ABCD     ABCD     ABCD     EMIR     EMIR  "
#
# NOTE: some lines are in range of old ABCD and new EMIR receivers - not
# defined in the paper of Agundez et al. (2012)

# conversion T_mb to T_A*
# conversion = " 0.6 0.6 0.6 0.6 0.6  0.6 0.6 0.6"

# ymax
ymax = " 0.06 0.18 0.23 0.17 0.23 0.34 0.32 0.29"

# ymin
ymin = " -0.007 -0.05 -0.09 -0.03 -0.04 -0.04 -0.04 -0.04"


do for [i=1:8:1] {

id=word(order,i)
idi=id+0
cnv=word(beff,idi)/word(feff,idi)
f1a=word(ymin,idi)
f1b=word(ymax,idi)

plot \
 [vel1:vel2] [f1a:f1b] \
 fileprofile \
 u ($2/1.e5+vlsr):(($1==id)?(($4*cnv)):1/0) \
 w l lw 2 lc "red" title "J=".(id+2)."-".(id+1)." max",\
 fileprofile1 \
 u ($2/1.e5+vlsr):(($1==id)?(($4*cnv)):1/0)\
 w l lw 2 lc "blue" title "mean",\
 fileprofile2 \
 u ($2/1.e5+vlsr):(($1==id)?(($4*cnv)):1/0)\
 w l lw 2 lc "green" title "min",\
 fileprofile3 \
 u ($2/1.e5+vlsr):(($1==id)?(($4*cnv)):1/0)\
 w l lw 2 lc "magenta" notitle  # "max"

}

unset xlabel
unset ylabel
unset ytics
unset mytics

