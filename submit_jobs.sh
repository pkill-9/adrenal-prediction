#!  /bin/bash
#
# Submits a PBS job for each of the test input files. The job is told
# which input file to use through a shell environment variable passed to
# the job using qsub's -v option.

if test ! -e ./stdout
then
    mkdir stdout
fi

if test ! -e ./stderr
then
    mkdir stderr
fi

for input_file in ./samples/*.in
do
    base_name=`basename "${input_file}" .in`
    qsub -v base_name=${base_name},input_dir="./samples/",output_dir="./spool" -e ./stderr -o ./stdout job.sh
done

# vim: ts=4 sw=4 et
