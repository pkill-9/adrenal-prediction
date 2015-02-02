% Octave script to create a data file for each sample in a bundle of
% samples. Each data file will be named according to the patient ID.

load ("input.mat");
print_profiles (input, "./samples/");

% vim: ft=octave ts=4 sw=4 et
