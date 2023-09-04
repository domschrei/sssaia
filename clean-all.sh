#!/bin/bash

for d in 03-decentralized-scheduling 04-scalable-distributed-sat 05-unsatisfiability-proofs 06-lilotane 07-distributed-sat-for-planning ; do
    cd $d
    bash clean.sh
    cd ..
done
