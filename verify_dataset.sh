#!  /bin/bash
#
# Compares the metadata from each test input with that of the corresponding
# expected output to make sure that they refer to the same urine sample.
# That is to say, input 00002.in and expected output 00002.exp refer to the
# same urine sample.

input_dir="./samples"
expected_output_dir="./output/original"

for input_file in ${input_dir}/*.src
do
    base_name=`basename ${input_file}`
    output_file="${expected_output_dir}/${base_name}"

    echo "Comparing ${input_file} with ${output_file}..."
    diff ${input_file} ${output_file} > /dev/null

    if test $? != 0
    then
        echo "verify fail. ${input_file} and ${output_file} from different samples."
    fi
done

# vim: ts=4 sw=4 et
