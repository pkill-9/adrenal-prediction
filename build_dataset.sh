#!  /bin/bash
#
# Creates the set of test inputs, extracted from a Matlab format binary
# file, and the expected outputs being the results from the original octave
# script.

if test ! -e samples
then
    mkdir samples
fi

if test ! -e output/original
then
    mkdir output/original
fi

octave -q write_profiles_to_files.m
octave -q script.m

# vim: ts=4 sw=4 et
