function [data idx] = get_data (indices,order,input_samples)
%% Function to return numerical values of steroid excretions and sample IDs of current input samples in one matrix
%% If parameter 'order' is set to one, the samples will be ordered according to the date of collection (relevant for reports)
%% Parameter 'sum_5pd_preg' specifies whether the metabolites 5-PD and Pregnadionol will be summed up in the steroid profile
%% For visualization in comparison to the control cohoert, summation is not necessary (here, only 5-PD is shown)
%% For classification, the two values need to be summed up to the new feature 'All-5PD'

% Empty arrays to store different parameters
% get_data([1:n_input_samples],0);
    steroids = zeros(32,length(indices));
    names = {};
    index = {};
    ids = {};
    data_type = zeros(1,length(indices));
    dobs = zeros(1,length(indices));
    collections = zeros(1,length(indices));
    analyses = zeros(1,length(indices));
    volumes = zeros(1,length(indices));

    % First select dates to sort the samples from old to new
    if order == 1
        for i=1:length(indices)
            collections(i) = input_samples(indices(i)).patient_data.doc;
        end
        % Find order of samples according to date of selection
        [values,idx] = sort(collections);
    else
        idx = [1:length(indices)];
    end

    % Collect all required information
    % Keep the order of the samples according to age
    % In the panel of steroid excretions, 5-PD and Pregnadienol are summed up
    for i=1:length(indices)
        % create a new function called get_profile()
        steroids(:,i) = get_profile(input_samples(indices(idx(i))).patient_data.steroid_profile);
    
    %    disp(input_samples(indices(idx(i))).patient_data.steroid_profile);
        names{i} = input_samples(indices(idx(i))).patient_data.number;
        index{i} = input_samples(indices(idx(i))).patient_data.index;
        ids{i} = input_samples(indices(idx(i))).patient_data.id;
        data_type(i) = input_samples(indices(idx(i))).patient_data.data_type;
        dobs(i) = input_samples(indices(idx(i))).patient_data.dob;
        volumes(i) = input_samples(indices(idx(i))).patient_data.total_volume;
        collections(i) = input_samples(indices(idx(i))).patient_data.doc;
        analyses(i) = input_samples(indices(idx(i))).patient_data.doa;
    end

    data.steroids = steroids;
    data.names = names;
    data.indices = index;
    data.ids = ids;
    data.data_type = data_type;
    data.dobs = dobs;
    data.volumes = volumes;
    data.collections = collections;
    data.analyses = analyses;
end