#!/bin/bash

for d in 04-scalable-distributed-sat 05-unsatisfiability-proofs 06-lilotane 07-distributed-sat-for-planning ; do
    cd $d
    bash plot.sh
    cd ..
done
