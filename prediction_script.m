% Predict whether a patient with an unkown growth on their adrenal gland
% has a malignant tumour or not.
%
% Data from a urine sample is provided to this script via stdin.
%
% A classifier should be specified using the -c|--classifier option, with
% a numeric classifier code following the option:
%   -c 1    classifier_19steroids
%   -c 2    classifier_32steroids
%   -c 3    classifier_lcms
%   -c 4    classifier_3steroids
[classifier_name classifier_code] = get_chosen_classifier (argv);

% read urine sample data.
data = get_profile_from_stdin ();
steroid_levels = data.levels;

xi_normalised_levels = normalize (steroid_levels, classifier_code);
printf ("debug: normalise levels done.\n");

[probs_high probs_low] = get_distance (classifier (classifier_name), ...
  xi_normalised_levels);
printf ("debug: get distance done.\n");

% print out results.
disp (round (probs_high * 100));

% vim: ts=4 sw=4 et
