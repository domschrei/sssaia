#!/bin/bash
#SBATCH --nodes=134
#SBATCH --ntasks=1600
#SBATCH --ntasks-per-node=12
#SBATCH --cpus-per-task=8
#SBATCH --ntasks-per-core=2 # enables hyperthreading
#SBATCH -t 02:01:00
#SBATCH -p general
#SBATCH --account=XXXXXX
#SBATCH -J run-sat-scheduling
#SBATCH --ear=off # Disable adaptive CPU speed for exact measurements
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

taskspernode=12
portfolio=kcl
timeout=7200
benchmarkfile="benchmark-2021-separated.txt"
nbenchmarks=$(cat $benchmarkfile|wc -l)
nparjobs=$nbenchmarks
nclients=16
wclimperjob=7200
# extra="-md=4" # activate for rigid scheduling!

cmd="
build/mallob -q -c=$nclients -ajpc=$nparjobs -mjps=$(($nbenchmarks / $nclients)) -sleep=100 -ljpc=4 -J=$nbenchmarks -T=$timeout -log=$logdir -v=4 \
-job-template=instances/job-template-isc22.json -job-desc-template=$benchmarkfile \
-client-template=instances/client-template-isc22.json -sro=${logdir}/processed-jobs.out -sjd=1 -jwl=$wclimperjob \
`#deployment` -rpa=1 -pph=$taskspernode -mlpt=25000000 -t=4 \
`#portfolio,diversification` -satsolver=$portfolio -isp=0.5 -div-phases=1 -div-noise=1 -div-elim=0 -div-seeds=1 -scsd=1 \
`#sharingsetup` -scll=60 -slbdl=60 -csm=2 -mlbdps=5 -cfm=3 -cfci=15 -mscf=5 -bem=1 -aim=1 -rlbd=0 -ilbd=1 \
`#sharingvolume` -s=0.5 -cbbs=750 -cblm=1 -cblp=100000 -cusv=1 \
`#randomseed` -seed=0 \
`#extra` $extra 
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
#PATH="build/:$PATH" RDMAV_FORK_SAFE=1 srun -n $SLURM_NTASKS $cmd
mpiexec -n $SLURM_NTASKS --bind-to core --map-by numa -print-rank-map $cmd
echo JOB_FINISHED