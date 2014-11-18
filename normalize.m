function xi_normalized = normalize (xi,classifier)
%% Preprocessing function; input is the 32-dim steroid profile
%% All data will be log transformed
%% GC-MS generated data will additionally be normalized with respect to healthy control group
%% Furthermore, necessary metabolites are extracted for different classifiers

    setenv('ACC_PATH','.');
    load(strcat(getenv('ACC_PATH'),'/normalization_values.mat'));
    normalization_values.mn_ctl = mn_ctl;
    normalization_values.std_ctl = std_ctl;

% Replace zeros by very small values and perform log transformation
    xi (find (xi==0)) = 10^(-10);
    xi = log (xi);

    % Different normalization procedures are necessary to different classifiers
    switch classifier
      case 1
        % Perform normalization with respect to healthy control group and extract relevant steroids
        xi = (xi - repmat(normalization_values.mn_ctl,size(xi,1),1))./repmat(normalization_values.std_ctl,size(xi,1),1);
        xi_normalized = xi(:,1:19);
      case 2
        % Perform normalization with respect to healthy control group
        xi_normalized = (xi - repmat(normalization_values.mn_ctl,size(xi,1),1))./repmat(normalization_values.std_ctl,size(xi,1),1);
      case 3
        % Extract relevant steroids
        % No normalization with respect to healthy controls in case of LC-MS/MS data
        xi_normalized = xi(:,[3 5 6 14 17 19]);

      case 4
        % Perform normalization with respect to healthy control group and extract relevant steroids
        xi = (xi - repmat(normalization_values.mn_ctl,size(xi,1),1))./repmat(normalization_values.std_ctl,size(xi,1),1);
        xi_normalized = xi(:,[5 6 19]);
    end
end
