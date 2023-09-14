#!/bin/bash

pyplotscale=0.9

# \textwidth ≈ 13 cm, i.e., 5.118 inch
fullwidth=$(echo "5.118 / $pyplotscale"|bc -l)
halfwidth=$(echo "$fullwidth / 2"|bc -l)
thirdwidth=$(echo "$fullwidth / 3"|bc -l)

plot_curves.py \
data/priorities/avg_volumes_per_prio -y2data=data/priorities/avg_response_times \
-xy -y2 -miny=0 -miny2=0 -nolegend -sizex=$(echo 0.55*$fullwidth|bc -l) -sizey=2.4 \
-labelx='Priority' -labely2='Mean response time [s]' -labely='Mean assigned volume $v_j$' \
-minx=-0.02 -maxx=1.03 -ticksx=0,0.25,0.5,0.75,1 -o=prio-volumes.pdf \
-topsymbols='-0.275;0;^;#377eb8,1.268;0;s;#ff7f00' -colors='#377eb8,#ff7f00'

plot_curves.py \
data/mallob_realistic_interarrival2.5/active-jobs -l='$1/\lambda=10\,$s' \
data/mallob_realistic_default/active-jobs -l='$1/\lambda=5\,$s' \
data/mallob_realistic_interarrival10/active-jobs -l='$1/\lambda=2.5\,$s' \
-nomarkers -labelx='Elapsed time [s]' -labely='Active jobs' -sizex=$(echo 0.6*$fullwidth|bc -l) -sizey=2 -xy \
-linestyles=- -legend-right -minx=0 -maxx=3600 -miny=0 -ticksx=0,1000,2000,3000 -gridx -gridy \
-o=chaos-active-jobs.pdf

plot_curves.py data/mallob_realistic_default/loads_slavg_{1,15,60}s -xy -nomarkers \
-minx=0 -maxx=3600 -miny=0.994 -maxy=1 -colors='#ffe5cc,#ffb266,#ff7f00' -linestyles=- \
-linewidths=0.1,0.8,1.4 -nolegend -sizex=$(echo 0.4*$fullwidth|bc -l) -sizey=2 \
-labelx="Elapsed time [s]" -labely="Utilization" -ticksx=0,1000,2000,3000 \
-o=utilization.pdf

plot_curves.py data/huca{0,10,100,infty}/histogram-init-normalized -xy \
-l='$h=0$' -l='$h=10$' -l='$h=100$' -l='$h=\infty$' -minx=0 -maxx=0.07 -miny=0.003 -maxy=0.27 \
-linestyles=-.,:,--,- -nomarkers -sizex=$halfwidth -sizey=2.2 -logy \
-labelx='Init. scheduling latency [s]' -labely='Density' -o=chaos-latency-init.pdf

plot_curves.py data/huca{0,10,100,infty}/histogram-treegrowth-normalized -xy \
-l='$h=0$' -l='$h=10$' -l='$h=100$' -l='$h=\infty$' -minx=0 -maxx=0.07 -miny=0.0005 -maxy=0.21 \
-linestyles=-.,:,--,- -nomarkers -sizex=$halfwidth -sizey=2.2 -logy \
-labelx='Tree growth latency [s]' -labely='Density' -o=chaos-latency-treegrowth.pdf

for nworkers in 96 384 1536; do
    plot_curves.py -title=$nworkers' processes' \
    data/latency-prefixsum/treegrowth-latencies_${nworkers}workers_prefixsum_cdf -l="P" \
    data/latency-prefixsum/treegrowth-latencies_${nworkers}workers_tree_cdf -l="T" \
    data/latency-prefixsum/treegrowth-latencies_${nworkers}workers_randomwalk_cdf -l="W" \
    -xy -minx=0 -maxx=0.045 -miny=0 -maxy=1 -nomarkers -linestyles=-,--,-. -lw=1.2 -sizex=1.895555 -sizey=2.2 \
    -labelx='Latency $t$ [s]' -labely='Pr[\,worker found in $\leq t$\,s\,]' -lloc=4 -gridx -gridy \
    -o=prefixsum-latencies_${nworkers}workers.pdf -ticksx=0.00,0.02,0.04 -ticksy=0.0,0.2,0.4,0.6,0.8,1.0
done
