#!/bin/bash

pyplotscale=0.9

# \textwidth ≈ 13 cm, i.e., 5.118 inch
fullwidth=$(echo "5.118 / $pyplotscale"|bc -l)
halfwidth=$(echo "$fullwidth / 2"|bc -l)
thirdwidth=$(echo "$fullwidth / 3"|bc -l)

function plot_buffer_limit_parametrization() {
    plot_curves.py \
    data/buflim/buffer-limit-scaling_param1 -l='$\alpha=1$' \
    data/buflim/buffer-limit-scaling_param0.875 -l='$\alpha=7/8$' \
    data/buflim/buffer-limit-scaling_param0.75 -l='$\alpha=6/8$' \
    data/buflim/buffer-limit-scaling_param0.625 -l='$\alpha=5/8$' \
    data/buflim/buffer-limit-scaling_param1000000 -l='$L=1\,000\,000$' \
    data/buflim/buffer-limit-scaling_param500000 -l='$L=500\,000$' \
    data/buflim/buffer-limit-scaling_param200000 -l='$L=200\,000$' \
    data/buflim/buffer-limit-scaling_param100000 -l='$L=100\,000$' \
    -linewidths=0.8,0.8,0.8,0.8,1.2,1.2,1.2,1.2 \
    -linestyles=-,--,-.,:,-,--,-.,: -lw=1.5 -markers=^,d,s,v,^,d,s,v -nomarkers \
    -colors=#ff7f00,#ff7f00,#ff7f00,#ff7f00,#377eb8,#377eb8,#377eb8,#377eb8 \
    -xy -miny=0 -maxy=1050000 -minx=0 -maxx=2000 \
    -labelx='$u$ (\# workers)' -labely='$b(u)$, $\tilde{b}(u)$' \
    -sizex=4.5 -sizey=2.7 -legendright -o=buffer-limit-functions.pdf
}

function plot_sateval_portfolio_crosschecking() {
    plot_curves.py \
    data/isc22-selection/oldcomp_portfolio-kcl/cdf -l='KCL' \
    data/isc22-selection/oldcomp_portfolio-kclg/cdf -l='KCLG' \
    data/isc22-selection/oldcomp_portfolio-klg/cdf -l='KLG' \
    data/isc22-selection/oldcomp_portfolio-clg/cdf -l='CLG' \
    data/isc22-selection/oldcomp_portfolio-kcg/cdf -l='KCG' \
    data/isc22-selection/oldcomp_portfolio-l/cdf -l='L' \
    data/isc22-selection/hordesat/cdf -l='Horde' \
    -xy -extend-to-right -minx=0 -maxx=300 -miny=0 -maxy=330 \
    -linestyles=--,:,--,-,-,-,: -lw=1 -nomarkers -markers=^,d,+,s,v,x,1 -markersize=4 \
    -colors='#377eb8,#ff7f00,#e41a1c,#ff7f00,#f781bf,#a65628,#999999,#dede00,#377eb8' \
    -lloc=4 -sizex=$halfwidth -sizey=3 \
    -labelx='Running time $t$ [s]' -labely='\# instances solved in $\leq t$\,s' \
    -o=sateval-portfolio-crosschecking.pdf
}

function plot_sateval_diversification() {
    plot_curves.py \
    data/isc22-selection/incrementlbds/cdf -l='$+$div. $+$sharing' \
    data/isc22-selection/nodiversification/cdf -l='$-$div. $+$sharing' \
    data/isc22-selection/nosharing/cdf -l='$+$div. $-$sharing' \
    data/isc22-selection/nosharing-nodiversification/cdf -l='$-$div. $-$sharing' \
    -linestyles=-,:,-,: -colors=blue,blue,orange,orange -no-markers -markersize=4 \
    -xy -extend-to-right -minx=0.15 -maxx=300 -miny=0 -maxy=330 -lloc=2 -sizex=3.3 -sizey=2.8 \
    -labelx='Running time $t$ [s]' -labely='\# instances solved in $\leq t$\,s' -logx \
    -o=sateval-portfolio-no-use-of-diversification-all-logx.pdf
}

function plot_sateval_clause_buffers() {
    plot_curves.py data/isc22-selection/{noadaptiveexport,incrementlbds}/clause-length-histogram \
    -l=Static -l=Adaptive -minx=0.5 -maxx=19.5 -miny=0 -maxy=0.255 -xy \
    -ticksx=1,3,5,7,9,11,13,15,17,19 -ticksy=0.0,0.05,0.10,0.15,0.20,0.25 \
    -sizex=3 -sizey=2.25 -labelx='Shared clause length' -labely='Density' \
    -o=sateval-clause-stores-clenhist-new.pdf
}

function plot_sateval_filter() {
    plot_curves.py \
    data/isc22-selection/reshareperiod30/cdf -l='Distr. $z=15\,s$' \
    data/isc22-selection/reshareperiod4/cdf -l='Distr. $z=2\,s$' \
    data/isc22-selection/bloomfiltering/cdf -l='Bloom' \
    data/isc22-selection/nofiltering/cdf -l='{None}' \
    -linestyles=-,--,-.,: -colors='blue,darkblue,orange,red' \
    -lw=1.2 -no-markers -markers=v,^,x -markersize=4 \
    -xy -extend-to-right -minx=0 -maxx=300 -miny=200 -maxy=330 -sizex=$halfwidth -sizey=2.6 \
    -labelx='Running time $t$ [s]' -labely='\# instances solved in $\leq t$\,s' \
    -o=sateval-clause-filtering.pdf
}

function plot_sateval_buflim_growth_params() {
    plot_curves.py \
    data/isc22-selection/L250k_32nodes/cdf -l='$m=32$, $L=250$k' \
    data/isc22-selection/alpha0.903121_32nodes/cdf -l='$m=32$, $\alpha\approx{}0.9$' \
    data/isc22-selection/L250k_16nodes/cdf -l='$m=16$, $L=250$k' \
    data/isc22-selection/alpha0.903121_16nodes/cdf -l='$m=16$, $\alpha\approx{}0.9$' \
    data/isc22-selection/L250k_8nodes/cdf -l='$m=8$, $L=250$k' \
    data/isc22-selection/alpha0.903121_8nodes/cdf -l='$m=8$, $\alpha\approx{}0.9$' \
    data/isc22-selection/L250k_4nodes/cdf -l='$m=4$, $L=250$k' \
    data/isc22-selection/alpha0.903121_4nodes/cdf -l='$m=4$, $\alpha\approx{}0.9$' \
    -linestyles=-,--,-,--,-,--,-,-- -colors=blue,blue,gray,gray,orange,orange,red,red -no-markers -markersize=3 \
    -xy -extend-to-right -minx=0 -maxx=299.5 -miny=200 -maxy=335 -lloc=4 \
    -sizex=$(echo "0.5 * $fullwidth"|bc -l) -sizey=3.2 -legend-spacing=0.25 \
    -labelx='Running time $t$ [s]' -labely='\# instances solved in $\leq t$\,s' \
    -o=sateval-buffer-scaling.pdf
}

function plot_sateval_scaling() {
    plot_curves.py \
    data/isc21/mallob_scaling_64x2x24/cdf -l='$64\times 2\times 24$' \
    data/isc21/mallob_scaling_32x2x24/cdf -l='$32\times 2\times 24$' \
    data/isc21/mallob_scaling_16x2x24/cdf -l='$16\times 2\times 24$' \
    data/isc21/mallob_scaling_8x2x24/cdf -l='$8\times 2\times 24$' \
    data/isc21/mallob_scaling_4x2x24/cdf -l='$4\times 2\times 24$' \
    data/isc21/mallob_scaling_2x2x24/cdf -l='$2\times 2\times 24$' \
    data/isc21/mallob_scaling_1x2x24/cdf -l='$1\times 2\times 24$' \
    data/isc21/mallob_scaling_1x1x24/cdf -l='$1\times 1\times 24$' \
    data/isc21/kissatmabhywalk/cdf -l='seq.' \
    -linestyles=-,--,-.,: -lw=1.4 -nomarkers -legend-spacing=0.25 \
    -xy -extend-to-right -minx=0 -maxx=300 -miny=0 -maxy=340 -sizex=$halfwidth -sizey=3.1 \
    -labelx='Running time $t$ [s]' -labely='\# instances solved in $\leq t$\,s' \
    -o=sateval-scaling-cdf.pdf
}

function plot_sateval_speedupscatter() {
    c=24
    ( echo "0.015 $c" ; echo "99999 $c" ) > .y$c
    plot_curves.py data/isc21/mallob_scaling_1x1x24/speedupscatter-{unsat,sat} -l='unsatisfiable' -l='satisfiable' \
    .y$c -l=None \
    -labelx='Running time of sequential solver [s]' -labely="Speedup at $c cores" -markersize=4 \
    -linestyles=None,None,: -xy -logx -logy -markers=x,+,None -gridx -gridy -colors='#ff7f00,#377eb8,#666666' \
    -sizex=$halfwidth -sizey=$halfwidth -minx=0.015 -maxx=99999 -miny=0.05 -maxy=500000 -potticks \
    -o=sateval-scatteredspeedups-${c}cores.pdf
    
    c=3072
    ( echo "0.015 $c" ; echo "99999 $c" ) > .y$c
    plot_curves.py data/isc21/mallob_scaling_64x2x24/speedupscatter-{unsat,sat} -l='unsatisfiable' -l='satisfiable' \
    .y$c -l=None \
    -labelx='Running time of sequential solver [s]' -labely="Speedup at $c cores" -markersize=4 \
    -linestyles=None,None,: -xy -logx -logy -markers=x,+,None -gridx -gridy -colors='#ff7f00,#377eb8,#666666' \
    -sizex=$halfwidth -sizey=$halfwidth -minx=0.015 -maxx=99999 -miny=0.05 -maxy=500000 -potticks \
    -o=sateval-scatteredspeedups-${c}cores.pdf
}

function plot_sateval_geomspeedups() {
    for suf in "" "-sat" "-unsat"; do
        cat data/isc21/mallob_scaling_{1x1,{1,2,4,8,16,32,64}x2}x24/geomspeedup$suf \
        | awk 'BEGIN{c=24} {print c,$1; c*=2}' > .geomspeedup-mallob$suf
        cat data/isc21/horde_{1x6,{1,2,4,8,16,32}x12}x4/geomspeedup$suf \
        | awk 'BEGIN{c=24} {print c,$1; c*=2}' > .geomspeedup-horde$suf
    done
    plot_curves.py \
    .geomspeedup-mallob-unsat -l='\textsc{MallobSat} (UNSAT)' \
    .geomspeedup-mallob -l='\textsc{MallobSat} (all)' \
    .geomspeedup-mallob-sat -l='\textsc{MallobSat} (SAT)' \
    .geomspeedup-horde-unsat -l='\textsc{HordeSat} (UNSAT)' \
    .geomspeedup-horde -l='\textsc{HordeSat} (all)' \
    .geomspeedup-horde-sat -l='\textsc{HordeSat} (SAT)' \
    -linestyles=--,--,--,-.,-.,-. -markers=v,d,^,v,d,^ -colors='#e41a1c,#377eb8,#ff7f00' \
    -markersize=4 -xy -miny=0 -minx=-10 -labelx='\# cores' -labely='Geometric mean speedup' \
    -ticksx='96,384,768,1536,3072' -sizex=4.75 -sizey=2.8 -gridy \
    -o=sateval-geomspeedups-mallob-vs-horde.pdf
}

function plot_sateval_mallob_v_horde() {
    # Direct comparison Mallob v Horde
    plot_curves.py \
    data/isc21/mallob_scaling_32x2x24/cdf -l='\textsc{MallobSat} KCL' \
    data/isc21/mallob_scaling-lingelingonly_32x2x24/cdf -l='\textsc{MallobSat} L' \
    data/isc21/horde_32x12x4/cdf -l='\textsc{HordeSat}' \
    -xy -minx=0 -maxx=300 -miny=0 \
    -labelx='Running time $t$ [s]' -labely='\# instances solved in $\leq t$\,s' \
    -nomarkers -extend-to-right -colors='#377eb8,#377eb8,#e41a1c' -linestyles=:,-,- -lw=1.3 \
    -sizex=$halfwidth -sizey=2.6 -o=cdf-mallob-vs-horde-final.pdf
}

function plot_sateval_sharing_v_nosharing() {
    plot_curves.py \
    data/isc21/mallob_scaling_64x2x24/cdf -l='Sharing' \
    data/isc21/mallob_scaling-nosharing_64x2x24/cdf -l='No sharing' \
    -xy -minx=0 -maxx=300 -miny=0 -nolegend \
    -labelx='Running time $t$ [s]' -labely='\# solved in $\leq t$\,s' \
    -nomarkers -extend-to-right -colors='#377eb8,#377eb8,#e41a1c' -linestyles=-,:,-,- -lw=1.3 \
    -title='Overall' -sizex=$thirdwidth -sizey=2 -ticksx=0,100,200,300 -ticksy=0,100,200,300 \
    -o=sateval-sharing-vs-nosharing-overall.pdf
    plot_curves.py \
    data/isc21/mallob_scaling_64x2x24/cdf-sat -l='Sharing' \
    data/isc21/mallob_scaling-nosharing_64x2x24/cdf-sat -l='No sharing' \
    -xy -minx=0 -maxx=300 -miny=0 -nolegend \
    -labelx='Running time $t$ [s]' -labely='\# solved in $\leq t$\,s' \
    -nomarkers -extend-to-right -colors='#377eb8,#377eb8,#e41a1c' -linestyles=-,:,-,- -lw=1.3 \
    -title='SAT' -sizex=$thirdwidth -sizey=2 -ticksx=0,100,200,300 -maxy=165 -ticksy=0,50,100,150 \
    -o=sateval-sharing-vs-nosharing-sat.pdf
    plot_curves.py \
    data/isc21/mallob_scaling_64x2x24/cdf-unsat -l='Sharing' \
    data/isc21/mallob_scaling-nosharing_64x2x24/cdf-unsat -l='No sharing' \
    -xy -minx=0 -maxx=300 -miny=0 -nolegend \
    -labelx='Running time $t$ [s]' -labely='\# solved in $\leq t$\,s' \
    -nomarkers -extend-to-right -colors='#377eb8,#377eb8,#e41a1c' -linestyles=-,:,-,- -lw=1.3 \
    -title='UNSAT' -sizex=$thirdwidth -sizey=2 -ticksx=0,100,200,300 -maxy=185 -ticksy=0,50,100,150 \
    -o=sateval-sharing-vs-nosharing-unsat.pdf
}

function plot_sateval_buflim_scaling() {
    
    cat data/isc21/mallob_scaling_{1x1,{1,2,4,8,16,32,64}x2}x24/mean-clause-length | awk 'BEGIN{c=1} {print c,$1; c*=2}' > .meanclslen
    plot_curves.py .meanclslen \
    -xy -nolegend -logx -labelx='\# workers' -labely='Clause length' \
    -ticksx=1,2,4,8,16,32,64,128 -minx=0.85 -maxx=150 -sizex=$halfwidth -sizey=1.6 \
    -miny=3 -maxy=7 -ticksy=3,4,5,6,7 -linestyles=: \
    -o=sateval-buflim-scaling-clslen.pdf
    
    cat data/isc21/mallob_scaling_{1x1,{1,2,4,8,16,32,64}x2}x24/median-admitted-literals | awk 'BEGIN{c=1} {print c,0.001*$1; c*=2}' > .medianadmittedlits
    plot_curves.py .medianadmittedlits \
    -xy -nolegend -logx -miny=0 -labelx='\# workers' -labely='k\,Lits shared' \
    -ticksx=1,2,4,8,16,32,64,128 -minx=0.85 -maxx=150 -sizex=$halfwidth -sizey=1.6 -linestyles=: \
    -o=sateval-buflim-scaling-litsshared.pdf
    
    cat .medianadmittedlits | awk '{print $1,1000*$2/(24*$1)}' > .medianadmittedlitspersolver
    plot_curves.py .medianadmittedlitspersolver \
    -xy -nolegend -logx -miny=0 -labelx='\# workers' -labely='Lits per solver' \
    -ticksx=1,2,4,8,16,32,64,128 -minx=0.85 -maxx=150 -sizex=$halfwidth -sizey=1.6 \
    -ticksy=0,50,100,150,200 -maxy=200 -linestyles=: \
    -o=sateval-buflim-scaling-litssharedpersolver.pdf
    
    cat data/isc21/mallob_scaling_{1x1,{1,2,4,8,16,32,64}x2}x24/mean-admitted-clause-ratio | awk 'BEGIN{c=1} {print c,$1; c*=2}' > .meanadmittedclauseratio
    plot_curves.py .meanadmittedclauseratio \
    -xy -nolegend -logx -labelx='\# workers' -labely='Admitted ratio' \
    -ticksx=1,2,4,8,16,32,64,128 -minx=0.85 -maxx=150 -sizex=$halfwidth -sizey=1.6 \
    -miny=0.7 -maxy=1.02 -ticksy=0.7,0.8,0.9,1.0 -linestyles=: \
    -o=sateval-buflim-scaling-admissionratio.pdf
}

function plot_disturbances() {
    plot_curves.py \
    data/malleable/disturbance/mallob_undisturbed_1536/cdf -l='1536' \
    data/malleable/disturbance/mallob_disturbance_768-to-1536/cdf.0 -l='768--1536' \
    data/malleable/disturbance/mallob_undisturbed_768/cdf -l='768' \
    data/malleable/disturbance/mallob_disturbance_384-to-1536/cdf.0 -l='384--1536' \
    data/malleable/disturbance/mallob_undisturbed_384/cdf -l='384' \
    -xy -extend-to-right -minx=0 -maxx=300 -miny=250 -maxy=335 -nomarkers \
    -linestyles=-,-.,-,-.,- -sizex=$halfwidth -sizey=2.7 \
    -labelx='Running time $t$ [s]' -labely='\# instances solved in $\leq t$\,s' \
    -o=sateval-disturbances-cdf.pdf
}

function plot_scheduling() {
    plot_curves.py \
    data/malleable/scheduling/mallob_1600x4_malleable/cdf -l='Mall 1600$\times$4' \
    data/malleable/scheduling/mallob_1600x4_rigid/cdf -l='Rigid 1600$\times$4' \
    data/malleable/scheduling/mallob_400x4_malleable/cdf -l='Mall 400$\times$4' \
    data/malleable/scheduling/mallob_400x4_rigid/cdf -l='Rigid 400$\times$4' \
    data/malleable/scheduling/mallob_400x1_malleable/cdf -l='Mall 400$\times$1' \
    data/isc21/kissatmabhywalk/cdf -l='400$\times$\textsc{Kissat}' \
    data/malleable/disturbance/mallob_undisturbed_1536/accumulated-cdf -l='OOS 1536 c.' \
    data/malleable/disturbance/mallob_undisturbed_384/accumulated-cdf -l='OOS 384 c.' \
    -extend-to-right -lloc=4 -legend-spacing=0.25 -minx=0 -maxx=7200 -miny=0 -maxy=355 -xy \
    -nomarkers -linestyles=-,--,-,--,-,--,:,: \
    -sizex=$halfwidth -sizey=3 -labelx='Total running time [s]' -labely='\# finished jobs' \
    -ticksx=0,1800,3600,5400,7200 -colors=orange,orange,red,red,blue,blue,#555555,#bbbbbb \
    -o=sateval-scheduling-cdf.pdf
}

function plot_isc22_post_comparison() {
    plot_curves.py \
    data/post-isc22/isc22-64hwthreads-kicaliglu-cdf.txt -l='\textsc{MallobSat} KCLG $\alpha$=$1$' \
    data/post-isc22/isc22-64hwthreads-parkissat-rs-cdf.txt -l='\textsc{ParkissatRS}' \
    data/post-isc22/isc22-64hwthreads-ki-cdf.txt -l='\textsc{MallobSat} K $\alpha$=$1$' \
    data/post-isc22/isc22-64hwthreads-li-cdf.txt -l='\textsc{MallobSat} L $\alpha$=$0.9$' \
    -xy -minx=0 -maxx=999 -miny=0 -maxy=300 \
    -labelx='Running time $t$ [s]' -labely='\# instances solved in $\leq t$\,s' \
    -nomarkers -extend-to-right -linestyles=:,-,--,-. -lw=1.3 \
    -sizex=$(echo "0.6*$fullwidth"|bc -l) -sizey=2.6 -o=isc22-rerun.pdf
}

function plot_weak_scaling_overview() {
    plot_curves.py data/isc21/mallob_weakscaling/mallob-speedups-min-tseq-{3072,1536,768,384,192,96,48,24} -l={3072,1536,768,384,192,96,48,24} -xy -minx=0 -miny=0 -maxy=800 -nomarkers -labelx='Sequential running time threshold $x$ [s]' -labely='Speedup on instances with $T_{seq}\geq x$' -sizex=$(echo "0.8*$fullwidth"|bc -l) -sizey=3 -legend-right -ticksy=0,100,200,300,400,500,600,700,800 -gridy -lw=1.2 -o=weak-scaling-overview.pdf
}

function plot_1v1_paracooba() {
    plot_1v1.py data/post-isc22/qtimes-anni-clo-paracooba-solved -l='Running time of \textsc{Paracooba} [s]' data/post-isc22/qtimes-anni-clo-mallob-solved -l='Running time of \textsc{MallobSat} [s]' -T=1000 -max=1500 -logscale -markersize=4 -domainmarkers=+,. -o=1v1-paracooba.pdf -size=$(echo "0.8*$fullwidth"|bc -l)
}

plot_buffer_limit_parametrization
plot_sateval_portfolio_crosschecking
plot_sateval_diversification
plot_sateval_clause_buffers
plot_sateval_filter
plot_sateval_buflim_growth_params
plot_sateval_scaling
plot_sateval_speedupscatter
plot_sateval_geomspeedups
plot_sateval_mallob_v_horde
plot_sateval_sharing_v_nosharing
plot_sateval_buflim_scaling
plot_disturbances
plot_scheduling
plot_isc22_post_comparison
plot_weak_scaling_overview
plot_1v1_paracooba
