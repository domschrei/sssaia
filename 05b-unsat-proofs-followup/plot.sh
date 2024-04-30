#!/bin/bash

pyplotscale=0.9

# \textwidth ≈ 13 cm, i.e., 5.118 inch
fullwidth=$(echo "5.118 / $pyplotscale"|bc -l)
halfwidth=$(echo "$fullwidth / 2"|bc -l)



function gmean() {
    left="$1"
    right="$2"
    awkcmd="$3"
    ( if [ "$right" == SINGLE ]; then
        cat $left
    else
        join --check-order $left $right
    fi ) |awk "$awkcmd"|datastats --raw|awk '{print $6,$1}'
}



( echo "0.0001 1" ; echo "10000 1" ) > .y1
for n in 1 20; do
    plot_curves.py .y1 -l=None \
    data/time-totaloverhead-mallobproof-${n}node.txt -l='all' \
    data/time-checkingoverhead-mallobproof-${n}node.txt -l='chk' \
    data/time-assemblyoverhead-mallobproof-${n}node.txt -l='asm' \
    -linestyles=-,None,None,None,None -markers='None,x,+,2' -gridx -gridy \
    -colors="black,#377eb8,#ff7f00,#e41a1c" -legend-spacing=0.1 \
    -markersize=4 -xy -logx -logy -minx=1.5 -maxx=300 -miny=0.008 -maxy=300 \
    -labelx='Solving time [s]' -labely='Relative overhead of proof stage [s]' \
    -sizex=$halfwidth -sizey=$halfwidth -title="${n}"'$\times$76' \
    -o=scatter-followup-n${n}.pdf
done




for n in 1 20; do
    echo Assembly overhead ${n}node: $(gmean data/qdata-mallobproof-${n}node.txt SINGLE 'NF >= 4 {print $4/$3}')
    echo Checking overhead ${n}node: $(gmean data/qdata-mallobproof-${n}node.txt SINGLE 'NF >= 5 {print $5/$3}')
    echo Checking overhead ${n}node w/ check timeouts: $(gmean data/qdata-mallobproof-${n}node-withfailedproofs.txt SINGLE 'NF >= 5 {print $5/$3}')
    echo Total overhead ${n}node: $(gmean data/qdata-mallobproof-${n}node.txt SINGLE 'NF >= 5 {print ($4+$5)/$3}')
    echo Total overhead ${n}node w/ check timeouts: $(gmean data/qdata-mallobproof-${n}node-withfailedproofs.txt SINGLE 'NF >= 5 {print ($4+$5)/$3}')
done

for n in 1 20; do
    echo Speedup of ${n}node best: $(gmean data/qdata-kissat.txt data/qdata-mallob-configbest-${n}node.txt '{print $3/$5}')
    echo Speedup of ${n}node prooflike: $(gmean data/qdata-kissat.txt data/qdata-mallob-configproof-${n}node.txt '{print $3/$5}')
    echo "Speedup of ${n}node proof (ST): $(gmean data/qdata-kissat.txt data/qdata-mallobproof-${n}node.txt '{print $3/$5}')"
    echo "Speedup of ${n}node proof (ST+Asm): $(gmean data/qdata-kissat.txt data/qdata-mallobproof-${n}node.txt '{print $3/($5+$6)}')"
    echo "Speedup of ${n}node proof (ST+Asm+Chk vs 2xKi): $(gmean data/qdata-kissat.txt data/qdata-mallobproof-${n}node.txt '{print (2*$3)/($5+$6+$7)}')"
done

echo 1node best over proof: $(gmean data/qdata-mallob-configbest-1node.txt data/qdata-mallobproof-1node.txt '{print $5/$3}')
echo 20node best over proof: $(gmean data/qdata-mallob-configbest-20node.txt data/qdata-mallobproof-20node.txt '{print $5/$3}')
echo 1node prooflike over proof: $(gmean data/qdata-mallob-configproof-1node.txt data/qdata-mallobproof-1node.txt '{print $5/$3}')
echo 20node prooflike over proof: $(gmean data/qdata-mallob-configproof-20node.txt data/qdata-mallobproof-20node.txt '{print $5/$3}')





plot_curves.py \
data/cdf-mallob-configbest-20node.txt -l='[1520$\times$] Best' \
data/cdf-mallob-configproof-20node.txt -l='[1520$\times$] Proof-like' \
data/cdf-mallobproof-20node.txt -l='[1520$\times$] \underline{Proof}' \
data/cdf-mallob-configbest-1node.txt -l='[76$\times$] Best' \
data/cdf-mallob-configproof-1node.txt -l='[76$\times$] Proof-like' \
data/cdf-mallobproof-1node.txt -l='[76$\times$] \underline{Proof}' \
data/cdf-gimsatul-76core.txt -l='[76$\times$] \underline{\textsc{Gimsatul}}' \
data/cdf-gimsatul-38core.txt -l='[38$\times$] \underline{\textsc{Gimsatul}}' \
data/cdf-kissat.txt -l='[1$\times$] \underline{\textsc{Kissat}}' \
-xy -nomarkers -minx=0 -maxx=300 -miny=0 -extend-to-right \
-labelx='Running time $t$ [s]' -labely='\# instances solved in $\leq t$' \
-gridx -gridy -sizex=$(echo "0.75*$fullwidth"|bc -l) -sizey=2.6 -legend-right \
-ticksx=0,60,120,180,240,300 -ticksy=0,50,100,150,200,250,300 \
-lw=1.2 -linestyles=:,-.,-,:,-.,-,--,:,: \
-colors='#e41a1c,#e41a1c,#e41a1c,#377eb8,#377eb8,#377eb8,#000000,#000000,#ff7f00' \
-o=cdf-followup.pdf
