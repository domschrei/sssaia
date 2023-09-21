#!/bin/bash

pyplotscale=0.9

# \textwidth ≈ 13 cm, i.e., 5.118 inch
fullwidth=$(echo "5.118 / $pyplotscale"|bc -l)
halfwidth=$(echo "$fullwidth / 2"|bc -l)
thirdwidth=$(echo "$fullwidth / 3"|bc -l)


cat data/ipc-followup-lilotane-satcalls-and-total | awk '{for (i=2;i<=NF-1;i++) print $i}' \
| sort -g | awk '{a[NR]=$1} END {for (x in a) {print a[x], x/NR}}' \
| plot_curves.py -xy -l=None -logx -nomarkers -lw=1.3 -minx=0.0008 -maxx=1800 -miny=0.63 -maxy=1.004 \
-labelx='Running time $x$ [s]' -labely='Pr\,[SAT call takes $\leq x$\,s]' \
-sizex=$halfwidth -sizey=2.7 -extend-to-right -potticksx -gridx -gridy \
-nolegend -o=lilotane-sat-call-duration-cdf.pdf

cat data/ipc-followup-lilotane-satcalls-and-total | awk '{sattime=0; for (i=2;i<=NF-1;i++) {sattime+=$i}; print $NF,sattime/$NF}' > .out
plot_curves.py .out -xy -markers='x' -markersize=4 -linestyles=None -l=None -miny=-0.02 -maxy=1.02 -minx=0.0013 -maxx=2200 -logx -gridx -gridy \
-labelx='Running time [s]' -labely='Ratio of time spent on SAT' -sizex=$halfwidth -sizey=2.7 \
-potticksx -nolegend -o=lilotane-scatter-ratio-of-sat-time.pdf


(echo "0 1"; echo "1 1") > .y1
plot_curves.py data/seqsatratio-to-mallotane-speedup .y1 \
-nolegend -xy -minx=0 -maxx=1 -miny=0.08 -logy -markers='x,None' -linestyles=None,- \
-colors='#377eb8,black' -markersize=4 -sizex=4 -sizey=2.7 -gridx -gridy \
-ticksx=0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1 -ticksy=0.125,0.25,0.5,1,2,4,8,16 \
-labelx='Ratio of time \textsc{Lilotane} spent on SAT calls' -labely='Speedup of \textsc{Mallotane}' \
-o=mallotane-speedup-by-seqsatratio.pdf


good='Elevator|Freecell|Logistics|Minecraft-P|Multiarm-B'
worst='Blocksworld-HPDDL|Entertainment|Towers'
other='Blocksworld-G|Childsnack|Depots|Factories|Hiking|Minecraft-R|Monroe|Robot|Snake|Woodworking'
cat data/qtimes-seq-lilotane | grep -E "$good" > .good
cat data/qtimes-seq-lilotane | grep -E "$worst" > .worst
cat data/qtimes-seq-lilotane | grep -vE "${good}|${worst}|${other}" > .bad
# bad domains which can be seen: Barman Satellite Transport Rover Assembly
cat data/qtimes-mallotane-2348cores-30min | grep -vE "$other" > .__
# remaining domains: BlocksworldG Childsnack Depots Factories Hiking MinecraftR MonroeFO MonroePO Robot Snake Woodworking 
# D,1,2,3,4,+,x,1,o,^,s,d,D,^,v,<,>,+,x,o,s,p,P,d,
cat .bad .worst .good > ._
plot_1v1.py ._ -l='Running time of seq. \textsc{Lilotane} [s]' .__ -l='Running time of \textsc{Mallotane} [s]' \
-min=0.01 -max=3000 -T=1800 -markersize=4.3 \
-domainmarkers='^,v,<,>,P,d,s,D,+,1,x,2,o' \
-domaincolors='#ff7f00,#ff7f00,#ff7f00,#ff7f00,#ff7f00,#e41a1c,#e41a1c,#e41a1c,#377eb8,#377eb8,#377eb8,#377eb8,#377eb8' \
-legendright -legend-cols=1 `#-legend-offset-y=-0.35` -legend-spacing=0.3 -logscale \
-size=4.8 -domainlabels='Assembly,Barman,Rover,Satellite,Transport,BlocksworldH,Entertainment,Towers,Elevator,Freecell,Logistics,MinecraftP,Multiarm' \
-o=scatter-lilotane-vs-mallotane-corrected.pdf
pdfcrop scatter-lilotane-vs-mallotane-corrected.pdf


plot_curves.py data/satcalls-{par,seq}-SAT-normcdf -xy -nomarkers -lw=1.4 -linestyles=-,: \
-l=M -l='L' -labelx='Running time $t$ [s]' -labely='Pr\,[call takes $\leq t$\,s]' \
-minx=0 -maxx=1600 -extend-to-right -miny=0.7 -maxy=1.01 -sizex=$thirdwidth -sizey=2.1 \
-ticksx=0,500,1000,1500 -lloc=4 -gridx -gridy \
-title='\textsc{SAT}' -o=mallotane-satcall-cdf-sat.pdf

plot_curves.py data/satcalls-{par,seq}-UNSAT-normcdf -xy -nomarkers -lw=1.4 -linestyles=-,: \
-l=M -l='L' -labelx='Running time $t$ [s]' -labely='Pr\,[call takes $\leq t$\,s]' \
-minx=0 -maxx=1300 -extend-to-right -miny=0.996 -maxy=1.0001 -sizex=$thirdwidth -sizey=2.1 \
-ticksx=0,500,1000 -lloc=4 -gridx -gridy -ticksy=0.996,0.997,0.998,0.999,1.000  \
-title='\textsc{UNSAT}' -o=mallotane-satcall-cdf-unsat.pdf

plot_curves.py data/satcalls-{par,seq}-UNSAT-normcdf -xy -nomarkers -lw=1.4 -linestyles=-,: \
-l=M -l='L' -labelx='Running time $t$ [s]' -labely='Pr\,[call takes $\leq t$\,s]' -lloc=4 \
-minx=0 -maxx=0.6 -extend-to-right -miny=0.5 -maxy=1 -sizex=$thirdwidth -sizey=2.1 \
-gridx -gridy -ticksx=0,0.2,0.4,0.6 -ticksy=0.5,0.6,0.7,0.8,0.9,1.0 \
-title='\textsc{UNSAT} ($\leq 0.6\,$s)' -o=mallotane-satcall-cdf-unsat-short.pdf


plot_curves.py data/volumehistory-assembly-depth07 -xy -nomarkers -lw=1 -linestyles=- \
-nolegend -labelx='Running time [s]' -labely='\# workers' \
-minx=0 -maxx=15 -miny=0 -maxy=13 -rect -sizex=$halfwidth -sizey=2.4 \
-ticksy=2,4,6,8,10,12 -gridy \
-o=mallotane-volumehistory-small.pdf

plot_curves.py data/volumehistory-assembly-depth07 -xy -nomarkers -lw=1 -linestyles=- \
-nolegend -labelx='Running time [s]' -labely='\# workers' -gridy -ticksy=0,2,4,6,8,10,12,14 \
-minx=0 -maxx=1115 -miny=0 -maxy=15.5 -rect -sizex=$halfwidth -sizey=2.4 \
-o=mallotane-volumehistory-big.pdf
