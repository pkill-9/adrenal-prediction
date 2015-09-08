#!  /bin/bash
#
# Shell script for running classifications on the local machine, as 
# opposed to running qsub jobs on HPC or sending jobs over SSH for the
# cloud. This is used for evaluating how long it takes to run a large
# number of jobs on a desktop machine, to gauge at what point does using
# a desktop PC become unfeasible.

output_dir="./spool"

if test ! -e ${output_dir}
then
    mkdir ${output_dir}
fi

for input_file in $1/*
do
    output_file=`basename ${input_file}`
    output_path="${output_dir}/${output_file}"

    octave -q ./prediction_script.m -c 1 < "${input_file}" > "${output_path}"
done

# vim: ts=4 sw=4 et
