#!  /bin/bash
#
#PBS -q parallel
#PBS -l nodes=2:ppn=1
#PBS -l walltime=00:10:00
#PBS -m a
#PBS -M m.signorini@student.unimelb.edu.au


cd ${PBS_O_WORKDIR}

module load octave/3.8.2
octave -V ./hello.m

# vim: ts=4 sw=4 et
