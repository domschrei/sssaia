#!/bin/bash

pyplotscale=0.9

# \textwidth ≈ 13 cm, i.e., 5.118 inch
fullwidth=$(echo "5.118 / $pyplotscale"|bc -l)
halfwidth=$(echo "$fullwidth / 2"|bc -l)
thirdwidth=$(echo "$fullwidth / 3"|bc -l)

(echo "0 1"; echo "1 1") > .y1

plot_curves.py data/seqsatratio-to-mallotane-speedup .y1 \
-nolegend -xy -minx=0 -maxx=1 -miny=0 -markers='x,None' -linestyles=None,- \
-colors='#377eb8,black' -markersize=4 -ticksy=1,5,10,15,20,25 -sizex=3.3 -sizey=2.7 \
-labelx='Ratio of time seq. Lilotane spent on SAT calls' -labely='Speedup of Mallotane' \
-o=mallotane-speedup-by-seqsatratio.pdf

good='Elevator|Freecell|Logistics|Minecraft-P|Multiarm-B'
worst='Blocksworld-HPDDL|Entertainment|Towers'
cat data/qtimes-seq-lilotane | grep -E "$good" > .good
cat data/qtimes-seq-lilotane | grep -E "$worst" > .worst
cat data/qtimes-seq-lilotane | grep -vE "${good}|${worst}" > .bad
cat .bad .worst .good > ._
plot_1v1.py ._ -l='Seq. Lilotane [s]' data/qtimes-mallotane-2348cores-30min -l='Mallotane [s]' \
-min=0.01 -max=3000 -T=1800 -markersize=5 \
-domainmarkers='^,v,<,>,+,x,o,s,p,P,d,D,1,2,3,4,+,x,1,o,^,s,d,D' \
-domaincolors='#bbb,#bbb,#bbb,#bbb,#bbb,#bbb,#bbb,#bbb,#bbb,#bbb,#bbb,#bbb,#bbb,#bbb,#bbb,#bbb,#ff7f00,#ff7f00,#ff7f00,#377eb8,#377eb8,#377eb8,#377eb8,#377eb8' \
-legendright -legend-cols=1 `#-legend-offset-y=-0.35` -legend-spacing=0.25 -logscale \
-xsize=5.35 -domainlabels='Assembly,Barman,BlocksworldG,Childsnack,Depots,Factories,Hiking,MinecraftR,MonroeFO,MonroePO,Robot,Rover,Satellite,Snake,Transport,Woodworking,BlocksworldH,Entertainment,Towers,Elevator,Freecell,Logistics,MinecraftP,Multiarm' \
-o=scatter-lilotane-vs-mallotane-corrected.pdf
pdfcrop scatter-lilotane-vs-mallotane-corrected.pdf

plot_curves.py data/volumehistory-assembly-depth07 -xy -nomarkers -lw=1 -linestyles=- \
-nolegend -labelx='Run time [s]' -labely='\# workers' \
-minx=0 -maxx=15 -miny=0 -maxy=13 -rect -sizex=$halfwidth -sizey=2.4 \
-ticksy=2,4,6,8,10,12 \
-o=mallotane-volumehistory-small.pdf

plot_curves.py data/volumehistory-assembly-depth07 -xy -nomarkers -lw=1 -linestyles=- \
-nolegend -labelx='Run time [s]' -labely='\# workers' \
-minx=0 -maxx=1115 -miny=0 -maxy=17 -rect -sizex=$halfwidth -sizey=2.4 \
-o=mallotane-volumehistory-big.pdf

plot_curves.py data/satcalls-{par,seq}-SAT-normcdf -xy -nomarkers -lw=1.4 -linestyles=-,: \
-l=M -l='L' -labelx='Run time $t$ [s]' -labely='Pr\,[call takes $\leq t$\,s]' \
-minx=0 -maxx=1600 -extend-to-right -miny=0.7 -maxy=1.01 -sizex=$thirdwidth -sizey=2.1 \
-ticksx=0,500,1000,1500 -lloc=4 \
-title='SAT' -o=mallotane-satcall-cdf-sat.pdf

plot_curves.py data/satcalls-{par,seq}-UNSAT-normcdf -xy -nomarkers -lw=1.4 -linestyles=-,: \
-l=M -l='L' -labelx='Run time $t$ [s]' -labely='Pr\,[call takes $\leq t$\,s]' \
-minx=0 -maxx=1300 -extend-to-right -miny=0.996 -maxy=1.0001 -sizex=$thirdwidth -sizey=2.1 \
-ticksx=0,500,1000 -lloc=4 \
-title='UNSAT' -o=mallotane-satcall-cdf-unsat.pdf

plot_curves.py data/satcalls-{par,seq}-UNSAT-normcdf -xy -nomarkers -lw=1.4 -linestyles=-,: \
-l=M -l='L' -labelx='Run time $t$ [s]' -labely='Pr\,[call takes $\leq t$\,s]' -lloc=4 \
-minx=0 -maxx=0.5 -extend-to-right -miny=0.5 -maxy=1.005 -sizex=$thirdwidth -sizey=2.1 \
-title='UNSAT ($\leq 0.5\,$s)' -o=mallotane-satcall-cdf-unsat-short.pdf
