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
-xy -nomarkers -minx=0 -maxx=1000 -miny=0 -extend-to-right -lw=1.2 \
-linestyles=:,-.,-,:,-.,-,--,:,: -colors='#e41a1c,#e41a1c,#e41a1c,#377eb8,#377eb8,#377eb8,#377eb8,#377eb8,#ff7f00' -linewidths=1.2,1.2,1.2,1.2,1.2,1.2,1.2,1.7,1.2 \
-sizex=$fullwidth -sizey=3 -labelx='Running time $t$ [s]' \
-labely='\# instances solved in $\leq t$ s' -legend-right \
-o=proof-production-cdf.pdf
