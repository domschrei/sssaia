#!/bin/bash

pyplotscale=0.9

# \textwidth ≈ 13 cm, i.e., 5.118 inch
fullwidth=$(echo "5.118 / $pyplotscale"|bc -l)
halfwidth=$(echo "$fullwidth / 2"|bc -l)
thirdwidth=$(echo "$fullwidth / 3"|bc -l)

function plot_sat_planners_cdf() {
    plot_curves.py \
    data/cdf-Lilotane-noopt -l='\textsc{Lilotane}' \
    data/cdf-LilotaneQ -l='\textsc{LilotaneQ}' \
    data/cdf-Tree-REX -l='\textsc{Tree-REX}' \
    data/cdf-PANDA-totSAT -l='\textsc{PANDA-totSAT}' \
    data/cdf-PANDA-SAT -l='\textsc{PANDA-SAT}' \
    data/cdf-PANDA-SAT-OPT -l='\textsc{PANDA-SAT-OPT}' \
    -xy -nomarkers -lw=1.3 -sizex=$(echo 0.75*$fullwidth|bc -l) -sizey=2.3 -miny=0 -minx=0 -maxx=300 -extend-to-right \
    -colors='#377eb8,#377eb8,#e41a1c,#ff7f00,#ff7f00,#ff7f00' -linestyles=-,--,:,-,--,-. \
    -legend-right -labelx='Running time $t$ [s]' -labely='\# instances solved in $\leq t$ s' \
    -ticksy=0,50,100,150,200,250 -o=PvTvL_runtimes.pdf
}

function plot_ipc_followup_cdfs() {
    plot_curves.py \
    data/cdf-ipc_run_{002,000,001,003,004}* -l='\textsc{Lilotane}' -l='\textsc{HyperTensioN}' -l='\textsc{Prelilotane}' -l='\textsc{LilotaneQ}' -l='\textsc{LilotaneQ+}' \
    -xy -nomarkers -lw=1.3 -sizex=$halfwidth -sizey=2.5 -miny=0 -minx=0 -maxx=1800 -extend-to-right \
    -colors='#377eb8,#e41a1c,#377eb8,#ff7f00,#ff7f00' -linestyles=-,-.,:,--,-. \
    -labelx='Running time $t$ [s]' -labely='\# instances solved in $\leq t$ s' \
    -o=ipc_runtimes.pdf
    
    plot_curves.py \
    data/cdf-pl-ipc_run_{002,000,001,003,004}* -l='\textsc{Lilotane}' -l='\textsc{HyperTensioN}' -l='\textsc{Prelilotane}' -l='\textsc{LilotaneQ}' -l='\textsc{LilotaneQ+}' \
    -xy -nomarkers -lw=1.3 -sizex=$halfwidth -sizey=2.5 -miny=0 -minx=0 -maxx=8000 -extend-to-right \
    -colors='#377eb8,#e41a1c,#377eb8,#ff7f00,#ff7f00' -linestyles=-,-.,:,--,-. \
    -labelx='Plan length $x$' -labely='\# instances with $|\pi|\leq x$' \
    -o=ipc_planlengths.pdf
}

function plot_lilotane_1v1s() {

    params="
    -logscale -size=$halfwidth -markersize=4.5
    -domainmarkers=^,v,<,>,+,x,o,s,p,P,d,D
    -ol=LvT_legend.pdf 
    -potticks
    "

    plot_1v1.py \
    data/qtimes_Lilotane_noopt -l='Running time of \textsc{Lilotane} [s]' \
    data/qtimes_Tree-REX -l='Running time of \textsc{Tree-REX} [s]' \
    -T=300 -max=600 $params \
    -o=LvT_runtimes.pdf
    
    plot_1v1.py \
    data/qtimes_Lilotane_noopt -l='Running time of \textsc{Lilotane} [s]' \
    data/qtimes_PANDA-totSAT -l='Running time of \textsc{PANDA-totSAT} [s]' \
    -T=300 -max=600 $params \
    -o=LvP_runtimes.pdf
    
    plot_1v1.py \
    data/qclauses_Lilotane -l='Clauses of \textsc{Lilotane}' \
    data/qclauses_Tree-REX -l='Clauses of \textsc{Tree-REX}' \
    -T=500000000 -max=100000000 $params \
    -o=LvT_clauses.pdf
    
    plot_1v1.py \
    data/qclauses_Lilotane -l='Clauses of \textsc{Lilotane}' \
    data/qclauses_PANDA-totSAT -l='Clauses of \textsc{PANDA-totSAT}' \
    -T=500000000 -max=100000000 $params \
    -o=LvP_clauses.pdf
}

plot_sat_planners_cdf
plot_ipc_followup_cdfs
plot_lilotane_1v1s
