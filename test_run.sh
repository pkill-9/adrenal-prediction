#!  /bin/bash
#
# Shell script to run the prediction program on every input file in the
# samples/ directory, and compare the output to the results of the
# original code (the two should match).

output_dir="./spool"

if test ! -e ${output_dir}
then
    mkdir ${output_dir}
fi

for input_file in ./samples/*
do
    base_name=`basename "${input_file}"`
    output_file="${output_dir}/${base_name}.out"
    diff_file="${output_dir}/${base_name}.diff"
    expected_output="output/original/${base_name}"

    echo -e "debug: output: ${output_file}\ndebug: input: ${input_file}"
    octave -q ./prediction_script.m -c 1 < "${input_file}" > "${output_file}"
    diff -u "${expected_output}" "${output_file}" > "${diff_file}"

    # diff has a nonzero exit status if the two files differ.
    if test $? != 0
    then
        failed_tests="${failed_tests} ${base_name}"
        failed_diffs="${failed_diffs} ${diff_file}"
    else
        delete_list="${delete_list} ${output_file} ${diff_file}"
    fi
done

/bin/rm -f ${delete_list}

if test "${failed_tests}" != ""
then
    echo "The following samples did not match the original results:" > .diff
    echo "${failed_tests}" >> .diff
    echo "Diffs follow. Hit n to go to the next diff." >> .diff
    less .diff ${failed_diffs}
    /bin/rm -f .diff
    exit 1
else
    echo "All outputs matched original."
    exit 0
fi

# vim: ts=4 sw=4 et
