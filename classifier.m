function this = classifier (filename)
% Constructor
    
% read model parameters from file
    load (filename)
    
    this.prototypes = w;
    this.c_prototypes = c_w;
    this.lambda = lambda;
    this.training_data = data;
    this.c_training_data = c_data;

    % generate classifier's representation in 2dimensional space
    % the data is first projected onto the first two eigenvectors of lambda
    % in the two dimensional space, the data is projected on the eigenvectors of the respective
    % covariance matrix of the data in 2D to rotate the data distribution
    [V1,E1] = eig(lambda);
    relevances = flipud(eig(lambda));

    % compute transformation matrix to project data to 2D
    V1 = fliplr(V1);
    this.omega = V1(:,1:2)'; 

    % derive 2dimensional representation of prototypes and training data
    this.relevances2d = [relevances(1),relevances(2)];
    this.prototypes2d = (this.omega * w')';
    this.training_data2d = (this.omega * data')';
    %this.prototypes2d = (this.omega * w')'.*repmat((relevances(1:2))',size(w,1),1);
    %this.training_data2d = (this.omega * data')'.*repmat((relevances(1:2))',size(data_2d,1),1);
    
    this.shifts = shifts;
    this.normalization_values = normalization_values;
end
