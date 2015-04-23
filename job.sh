#!  /bin/bash
#
#PBS -q serial
#PBS -l walltime=00:10:00
#PBS -m a
#PBS -M m.signorini@student.unimelb.edu.au


cd ${PBS_O_WORKDIR}

touch "./running-jobs/${JOB_ID}"

module purge
module load octave/3.8.2

input_file="${input_dir}/${base_name}.in"
output_file="${output_dir}/${base_name}.out"

octave -q ./prediction_script.m --classifier 1 < ${input_file} > ${output_file}

rm -f "./running-jobs/${JOB_ID}"

# vim: ts=4 sw=4 et
