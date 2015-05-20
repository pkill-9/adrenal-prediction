#!  /bin/bash
#
# Script to generate a larger dataset by random permutations of the
# existing sample files.
#
# Usage:
# scramble.sh numsamples samplepath outputpath
#
# Where samplepath is a directory containing the existing set of samples,
# and outputpath is a directory where the scrambled dataset will be placed.
# numsamples specifies how many samples should be in the scrambled data
# set.

for ((i = 0; i < $1; i ++))
do
    destfile=`mktemp -p $3 XXXXXXX`
    srcfile=`ls $2 | sort -R | head -1`
    cat $2/$srcfile >> $destfile
done

# vim: ft=sh ts=4 sw=4 et
