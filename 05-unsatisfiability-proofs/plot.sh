#!/bin/bash

pyplotscale=0.9

# \textwidth ≈ 13 cm, i.e., 5.118 inch
fullwidth=$(echo "5.118 / $pyplotscale"|bc -l)
halfwidth=$(echo "$fullwidth / 2"|bc -l)

plot_curves.py \
data/cdf-mallob1600-kicaliglu -l='\textsc{MallobSat1600-KCLG}' \
data/cdf-mallob1600-ca -l='\textsc{MallobSat1600-C}' \
data/cdf-mallobp1600 -l='\textsc{MallobSatP1600}' \
data/cdf-parkissatrs -l='\textsc{ParkissatRS}' \
data/cdf-mallob64-ca -l='\textsc{MallobSat64-Ca}' \
data/cdf-mallobp64-seq -l='\textsc{MallobSatP64} (Seq.)' \
data/cdf-mallobp64-par -l='\textsc{MallobSatP64} (Par.)' \
data/cdf-gimsatul -l='\textsc{Gimsatul}' \
data/cdf-kissatmabhywalk -l='\textsc{KissatMABHyWalk}' \
-xy -nomarkers -minx=0 -maxx=1000 -miny=0 -maxy=350 -extend-to-right -lw=1.2 \
-linestyles=:,-.,-,:,-.,-,--,:,: -colors='#e41a1c,#e41a1c,#e41a1c,#377eb8,#377eb8,#377eb8,#377eb8,#377eb8,#ff7f00' \
-linewidths=1.2,1.2,1.2,1.2,1.2,1.2,1.2,1.7,1.2 -gridx -gridy \
-sizex=$(echo "0.85*$fullwidth"|bc -l) -sizey=2.6 -labelx='Running time $t$ [s]' \
-ticksx=0,250,500,750,1000 \
-labely='\# instances solved in $\leq t$ s' -legend-right \
-o=proof-production-cdf.pdf

( echo "0.0001 1" ; echo "10000 1" ) > .y1

mode=par; plot_curves.py .y1 -l=None \
data/${mode}-solvingtime-lrattime-ratio -l='all' \
data/${mode}-solvingtime-lratchecktime-ratio -l='chk' \
data/${mode}-solvingtime-lratpostprocesstime-ratio -l='post' \
data/${mode}-solvingtime-lratcombinetime-ratio -l='asm' \
-linestyles=-,None,None,None,None -markers='None,x,+,1,2' -gridx -gridy \
-colors="black,#377eb8,#ff7f00,#08f,#e41a1c" -legend-spacing=0.1 \
-markersize=4 -xy -logx -logy -minx=2.5 -maxx=1000 -miny=0.001 -maxy=300 \
-labelx='Solving time [s]' -labely='Relative overhead of proof stage [s]' \
-sizex=$halfwidth -sizey=$halfwidth -title='\textsc{MallobSatP64} (Par.)' \
-o=proof-scatter-parallel.pdf

mode=cld; plot_curves.py .y1 -l=None \
data/${mode}-solvingtime-lrattime-ratio -l='all' \
data/${mode}-solvingtime-lratchecktime-ratio -l='chk' \
data/${mode}-solvingtime-lratpostprocesstime-ratio -l='post' \
data/${mode}-solvingtime-lratcombinetime-ratio -l='asm' \
-linestyles=-,None,None,None,None -markers='None,x,+,1,2' -gridx -gridy \
-colors="black,#377eb8,#ff7f00,#08f,#e41a1c" -legend-spacing=0.1 \
-markersize=4 -xy -logx -logy -minx=2.5 -maxx=1000 -miny=0.001 -maxy=300 -lloc=3 \
-labelx='Solving time [s]' -labely='Relative overhead of proof stage [s]' \
-sizex=$halfwidth -sizey=$halfwidth -title='\textsc{MallobSatP1600}' -nolegend \
-o=proof-scatter-cloud.pdf
