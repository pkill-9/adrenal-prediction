classifier_selected = "1";

load('input.mat');
input_samples = struct('patient_data',sample('','','',NaN,NaN,NaN,1,0,nan(1,32)));
n_input_samples = 0;
youngest = datenum('01/01/1900','dd/mm/yyyy');

for i=1:size(input,2)
    % Generate sample objects from input data and add it to the list of currently loaded samples
    sample_i = sample(input(i).patient,input(i).index,input(i).sample_id,input(i).dob,input(i).date_of_collection,input(i).date_of_analysis,input(i).data_type,input(i).total_volume,input(i).steroid_profile);
    input_samples(n_input_samples+1).patient_data = sample_i;

    % Increase number of samples currently loaded by 1
    n_input_samples = n_input_samples + 1;

    % Update index of youngest sample, if necessary
    if sample_i.doc > youngest
        youngest = sample_i.doc;
    end
end

data = get_data([1:n_input_samples],0,input_samples);
steroids = data.steroids;

%selection = find(event.Data);
%lin 19/09/14
%we create our own selection
selection = 1:1:size(input,2);
%	selection = [6
%		7
%		8
%		9
%		10];
lc_ms_ms = find(data.data_type(selection)==1);
gc_ms = find(data.data_type(selection)==2);
%classifier_selected has 4 types: 1-4 {{{ 1:19, 2:32, 3:lcms, 4:3}}}

%xi_norm = normalize(steroids(:,selection(gc_ms))',1);
%for i=1:size(xi_norm,1)	
%	[probs_high probs_low] = get_distance (classifier('classifier_19steroids.mat'), xi_norm(i,:));
%	disp(probs_high);
%end

printf("%s\n","The probability of ") % Write a description 

classifier_selected = str2num(classifier_selected);

switch classifier_selected
case 1
    filename = 'classifier_19steroids.mat';

case 2
    filename = 'classifier_32steroids.mat';

case 3
    filename = 'classifier_lcms.mat';

case 4
    filename = 'classifier_3steroids.mat';
end

xi_norm = normalize(steroids(:,selection(gc_ms))',classifier_selected);
% how many sample selected

for i=1:size(xi_norm,1)
    [probs_high probs_low] = get_distance (classifier(filename), xi_norm(i,:));

    output_filename = strcat ("./output/original/", data.indices (i));
    output_file = fopen (output_filename, "wt");
    fdisp(output_file, round(probs_high*100));
end

% vim: ft=octave ts=4 sw=4 et
