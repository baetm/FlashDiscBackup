#!/usr/bin/gnuplot
#
#
# set terminal postscript landscape enhanced mono dashed lw 0.5  "Times-Roman" 12  #'Helvetica' 10
# set terminal postscript eps enhanced color dashed lw 1.0 size 3.50,5.70 "Times-Roman" 16 #'Helvetica' 10
# set terminal postscript eps enhanced color dashed lw 1.0 size 4.87,2.20 "Times-Roman" 16 #'Helvetica' 10
# set output 'figure.cwleo.alf.var.eps'


vlsr=-16.7
vel1=-45.+vlsr
vel2=+45.+vlsr

# set ylabel "Flux Density (Jy/beam)"
# set ylabel "T_A^{\*} (K)"
set ylabel "T_{MB} (K)"
set xlabel "V_{LSR} (km/s)"
set format y "%.1f"
set format x "%.0f"
set xtics  30.
set mxtics 3
set ytics  0.1
set mytics 5

fileprofile='profile.co'
#fileprofile1='profile.cwleo.mean.alf'
#fileprofile1='empty.dat'
#fileprofile2='profile.cwleo.min.alf'
#fileprofile3='empty.dat'
# fileprofile3='profile.cwleo.max.alf'


set multiplot layout 2,2 \
             margins 0.10,0.98,0.1,0.98 \
             spacing 0.12,0.06

f1a=-0.1
f1b=0.4

# based on work on observations ATC of CO 2-1 in Egg nebula
# conversion=1./0.63


# order panels
order = "1 2 3 4"


# molecule CO   transition=    2 frequency=   115.2712 GHz   hpbw=   21.0 (arcsec)  offset=    0.0
# molecule CO   transition=    4 frequency=   230.5380 GHz   hpbw=   11.0 (arcsec)  offset=    0.0
# molecule CO   transition=    6 frequency=   345.7960 GHz   hpbw=   18.1 (arcsec)  offset=    0.0
# molecule CO   transition=    8 frequency=   461.0408 GHz   hpbw=   13.5 (arcsec)  offset=    0.0                                                                                                                                                          
freqGHz= " 115.2712  230.5380 345.7960 461.0408"
# wavemm=  "  2.6       1.3      0.9      0.7    "
feff=    "  1.0     1.0     1.0     1.0"
beff=    "  0.78    0.58    0.62    0.62"
# receiver="  ABCD     ABCD     ABCD     ABCD     ABCD     ABCD     EMIR     EMIR  "
#
# NOTE: some lines are in range of old ABCD and new EMIR receivers - not
# defined in the paper of Agundez et al. (2012)

# conversion T_mb to T_A*
conversion = " 0.6 0.6 0.6 0.6"

# ymax
ymax = " 2.0 6.2 1.7 1.9"

# ymin
ymin = " -0.1 -0.1 -0.1 -0.1"


do for [i=1:4:1] {

#id=word(order,i)
#idi=id+0

#cnv=word(beff,i)/word(feff,i)
cnv=word(feff,i)/word(beff,i)
f1a=word(ymin,i)
f1b=word(ymax,i)

plot \
 [vel1:vel2] [f1a:f1b] \
 fileprofile \
 u ($2/1.e5+vlsr):(($1==i)?(($4*cnv)):1/0) \
 w l lw 2 lc "red" title "J=".(i)."-".(i-1) #,\
 #fileprofile1 \
 #u ($2/1.e5+vlsr):(($1==id)?(($4*cnv)):1/0)\
 #w l lw 2 lc "blue" title "mean",\
 #fileprofile2 \
 #u ($2/1.e5+vlsr):(($1==id)?(($4*cnv)):1/0)\
 #w l lw 2 lc "green" title "min",\
 #fileprofile3 \
 #u ($2/1.e5+vlsr):(($1==id)?(($4*cnv)):1/0)\
 #w l lw 2 lc "magenta" notitle  # "max"

}

unset xlabel
unset ylabel
unset ytics
unset mytics

