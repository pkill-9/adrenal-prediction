#!  /bin/bash
#
#PBS -q serial
#PBS -l walltime=00:10:00
#PBS -m a
#PBS -M m.signorini@student.unimelb.edu.au


cd ${PBS_O_WORKDIR}
. const.sh

input_files=`ls ${INPUT_DIR} | head --lines=$(($1 + ${SAMPLES_PER_RUN})) | \
    tail --lines=${SAMPLES_PER_RUN}`

module purge
module load octave/3.8.2

for input_file in ${input_files}
do
    output_file=${OUTPUT_DIR}/`basename ${input_file}`
    octave -q ./prediction_script.m --classifier 1 < ${input_file} > ${output_file}
done

# vim: ts=4 sw=4 et
