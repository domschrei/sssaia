#!/bin/bash
#SBATCH --nodes=16
#SBATCH --ntasks-per-node=2
#SBATCH --cpus-per-task=48
#SBATCH --ntasks-per-core=2 # enables hyperthreading
#SBATCH -t 7:00:00
#SBATCH -p micro # micro for nodes<=16, general for nodes>16
#SBATCH --account=XXXXXX
#SBATCH -J run-sat-benchmark # job name
#SBATCH --ear=off # Disable adaptive CPU speed for exact measurements
#SBATCH --switches=1 # Force experiments onto a single island
# SBATCH --ear-mpi-dist=openmpi # If using OpenMPI

# SuperMUC has TWO processors with 24 physical cores each, totalling 48 physical cores (96 hwthreads)
# See: https://doku.lrz.de/download/attachments/43321076/SuperMUC-NG_computenode.png

# Experiments were performed on Mallob corresponding to this version:
# https://github.com/domschrei/mallob/tree/72cab2a743ab5166deaac1c8fd784ef1cbac6fd3

# Load same modules to compile
module load slurm_setup; module unload devEnv/Intel/2019 intel-mpi; module load gcc/11 intel-mpi/2019-gcc cmake/3.14.5 gdb

# Debugging output
module list
which mpirun
echo "#ranks: $SLURM_NTASKS"

# HOME
logdir=logs/mallob_sat-benchmark_$SLURM_JOB_ID
# WORK
if [ -d $WORK_XXXXXX ]; then logdir="$WORK_XXXXXX/$logdir"; fi

nparjobs=1
taskspernode=2
portfolio=kclg
timeout="$((7*3600 - 60))" # 7 hours - epsilon
benchmarkfile="benchmark.txt"
nbenchmarks=$(cat $benchmarkfile|wc -l)

cmd="
build/mallob -q -c=1 -ajpc=$nparjobs -sleep=1000 -ljpc=8 -J=$nbenchmarks -T=$timeout -log=$logdir -v=4 \
-job-template=instances/job-template-isc22.json -job-desc-template=$benchmarkfile \
-client-template=instances/client-template-isc22.json -sro=${logdir}/processed-jobs.out -sjd=1 -jwl=300 \
`#deployment` -rpa=1 -pph=$taskspernode -mlpt=50000000 -t=24 \
`#portfolio,diversification` -satsolver=$portfolio -isp=0.5 -div-phases=1 -div-noise=1 -div-seeds=1 -scsd=1 \
`#sharingsetup` -scll=60 -slbdl=60 -csm=2 -mlbdps=5 -cfm=3 -cfci=30 -mscf=5 -bem=1 -aim=1 -rlbd=0 -ilbd=1 \
`#sharingvolume` -s=0.5 -cbbs=4500 -cblm=1 -cblp=100000 -cusv=1 \
`#randomseed` -seed=0
"

mkdir -p "$logdir"
oldpath=$(pwd)
cd "$logdir"
for rank in $(seq 0 $(($SLURM_NTASKS-1))); do
        mkdir $rank
done
cd "$oldpath"

export PATH="build/:$PATH"
export RDMAV_FORK_SAFE=1
export MALLOC_CONF="thp:always"

echo JOB_LAUNCHING
echo "$cmd"
mpiexec -n $SLURM_NTASKS --bind-to core --map-by numa -print-rank-map $cmd
echo JOB_FINISHED
