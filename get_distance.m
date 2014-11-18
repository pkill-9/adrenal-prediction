function [probs_high probs_low] = get_distance (this,xi)
%% Compute distances of current input samples to prototypes in high- and low dimensional feature space
%% Compute assignment probabilities

% perform normalization with respect to training data
    xi = (xi - this.normalization_values.mean)./this.normalization_values.std;
    % exclude missing values
    indices_nan = find (isnan(xi));
    xi (indices_nan) = 0;
    
    % copy current prototype settings
    % set missing dimensions to zero
    w_intermediate = this.prototypes;
    w_intermediate (:,indices_nan) = 0;

    % compute distances to prototypes in high dimensional space
    dist_high = diag (((xi(ones(size(w_intermediate,1),1),:))-w_intermediate)*this.lambda*((xi(ones(size(w_intermediate,1),1),:))-w_intermediate)');
    % add shift to achieve a classifier with equal sensitivity and specificity
    % the required value was derived by ROC analysis
    dist_high(1) = dist_high(1) + this.shifts(1);

    % compute assignment probabilities according to Bayes' theorem
    % assume normally distributed data around the prototype and equal prior probability of both classes
    densities_high = exp(-0.5*dist_high);
    probs_high = densities_high ./ sum(densities_high);

    % compute distance to prototypes in two dimensional space
    % this is only possible, if samples do not contain missing values
    % normalize distance with respect to dimensionality, because this is included in the matrix lambda
    % subsequently, compute assignment probabilities
    if length(indices_nan) == 0
        xi_transform = (this.omega*xi')';
        dist_low = sum(repmat(this.relevances2d,2,1).*((xi_transform(ones(size(w_intermediate,1),1),:) - this.prototypes2d).^2),2);
        dist_low(1) = dist_low(1) + this.shifts(2);
        densities_low = exp(-0.5*dist_low);
        probs_low = densities_low ./ sum(densities_low);
    else
        xi_transform = [NaN NaN];
        dist_low = [NaN NaN];
        probs_low = [0 0];
    end
end