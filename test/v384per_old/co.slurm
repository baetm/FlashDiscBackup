#!/bin/sh
# ----------------------------------------------------
# slurm script: 
# wave_mpi.pbs
#
# compilation: 
# mpif90 wave_mpi.f90 -o wave_mpi.x
#
# syntax: 
# sbatch co.slurm
#
# ----------------------------------------------------
# jubork:
# ssh medusa-01
# chmod +x wave_mpi.pbs
# qsub ./wave_mpi.pbs
# [qstat]
# [qsig -s SIGINT jobid]
#
# vmem is virtual memory per node !!!
# ----------------------------------------------------
#SBATCH --time=1:00:00
#SBATCH --mem-per-cpu=2072
#SBATCH --ntasks 4
## SBATCH -c 30
#SBATCH -p pmedusa
#
# WORK_DIRECTORY=/unsaved/medusa-20_1/schmidt/work_${SLURM_JOBID}
# mkdir ${WORK_DIRECTORY}
# echo "${WORK_DIRECTORY}"


#
# echo "${SLURM_SUBMIT_DIR}"
# echo "${SLURM_JOBID}"
# echo "${SLURM_SUBMIT_HOST}"
# echo "${SLURM_JOB_NODELIST}"

#
# setenv medusanodelist `cat ${SLURM_JOB_NODELIST}`
medusanodelist=`cat ${SLURM_JOB_NODELIST}`
# OMP_NUM_THREADS=16
# echo "nodefile name : ${SLURM_JOB_NODELIST}"
# echo "nodefile list : `cat ${SLURM_JOB_NODELIST}`"

# cd ${WORK_DIRECTORY}

echo ========== runtime environment =========== 
echo "submission host : ${SLURM_SUBMIT_HOST}" 
echo "execution queue : ${SLURM_JOB_PARTITION}" 
echo "working directory : ${SLURM_SUBMIT_DIR}" 
echo "batch id : ${SLURM_JOBID}" 
echo "job name : ${SLURM_JOB_NAME}" 
echo "nodefile name : ${SLURM_JOB_NODELIST}" 
# echo "node list : `cat ${SLURM_JOB_NODELIST}`"

# /usr/bin/mpirun -wdir /home/schmidt/CODES/MPICH/medusa wave_mpi.x

# /usr/bin/mpirun -np 41 -machinefile ${SLURM_JOB_NODELIST} -bind-to socket -wdir /home/schmidt/CODES/MOLEXCSE/branch32/mpich.src.f90 ./a.out
# /usr/bin/mpirun -np 9 -machinefile ${SLURM_JOB_NODELIST} -wdir /home/schmidt/CODES/MOLEXCSE/branch32/hcn_version_25.01  ./a.out input.hcn_7lev
# /usr/bin/mpirun -np 60 -machinefile ${SLURM_JOB_NODELIST} -wdir /home/schmidt/CODES/MOLEXCSE/branch32/schonberg  ../version_integral_observer_tau/a.out input.sis
# /usr/bin/mpirun -np 80 -machinefile ${SLURM_JOB_NODELIST} -wdir /home/schmidt/CODES/MOLEXCSE/branch32/cwleo_sis  ../version_integral_observer_tau/a.out input.cwleo_sis
# /usr/bin/mpirun -np 4 ./a.out input.co
/usr/bin/srun  ../molexcse.src/a.out input.co
