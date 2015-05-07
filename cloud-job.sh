#!  /bin/bash
#
# Script for running the Octave based classifier on a VM. This is different
# to HPC, since we do not need to load any modules for the VM; all the
# necessary software is installed.
#
# When this script is run, it should be given three environment variables,
# input_dir, output_dir and base_name, which describe the directories where
# the sample file is located and where an output file is to be placed, and
# the name of the sample file. The output file will be given the same name,
# so input and output files must be kept in separate directories.

input_file="${input_dir}/${base_name}"
output_file="${output_dir}/${base_name}"

octave -q ./prediction_script.m --classifier 1 < ${input_file} > \
    ${output_file}

# vim: ts=4 sw=4 et
