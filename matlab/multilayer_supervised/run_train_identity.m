% runs training procedure for supervised multilayer network
% softmax output layer with cross entropy loss function

%% setup environment
% experiment information
% a struct containing network layer sizes etc
ei = [];

% add common directory to your path for
% minfunc and mnist data helpers
addpath ../common;
addpath(genpath('../common/minFunc_2012/minFunc'));

%% TODO: load face data

[sinG,cosG]=get_gabors;
[pofas,nims]=load_images;
[conns,fullConns] = convolveImages(nims,sinG,cosG);
zscored=zscoreImgs(conns);
reducedNims=reducedDims(zscored);


[data_train,labels_train,data_test,labels_test]=separateData(nims,reducedNims);
maxID=max(cat(1,labels_train,labels_test));
minID=min(cat(1,labels_train,labels_test));

labels_train = labels_train-minID+1;
labels_test = labels_test-minID+1;

newmaxID=max(cat(1,labels_train,labels_test));
newminID=min(cat(1,labels_train,labels_test));

%% populate ei with the network architecture to train
% ei is a structure you can use to store hyperparameters of the network
% You should be able to try different network architectures by changing ei
% only (no changes to the objective function code)


%TODO: decide proper hyperparameters.
% dimension of input features FOR YOU TO DECIDE
ei.input_dim = 40;
% number of output classes FOR YOU TO DECIDE
ei.output_dim = 23;
% sizes of all hidden layers and the output layer FOR YOU TO DECIDE
ei.layer_sizes = [30, ei.output_dim];
% scaling parameter for l2 weight regularization penalty
ei.lambda = 1e-5;
% which type of activation function to use in hidden layers
% feel free to implement support for different activation function
ei.activation_fun = 'logistic';

%% setup random initial weights
stack = initialize_weights(ei);
params = stack2params(stack);

%% setup minfunc options
options = [];
options.display = 'iter';
options.maxFunEvals = 1e6;
options.Method = 'lbfgs';

%% run training
[opt_params,opt_value,exitflag,output] = minFunc(@supervised_dnn_cost,...
    params,options,ei, data_train, onehot(labels_train,newmaxID));

% TODO:  1) check the gradient calculated by supervised_dnn_cost.m
%        2) Decide proper hyperparamters and train the network.
%        3) Implement SGD version of solution.
%        4) Plot speed of convergence for 1 and 3.
%        5) Compute training time and accuracy of train & test data.

finalStack = params2stack(opt_params, ei);

%% compute accuracy on the test and train set
[~, ~, pred] = supervised_dnn_cost( opt_params, ei, data_test, [], true);
[~,pred] = max(pred);
acc_test = mean(pred'==labels_test);
fprintf('test accuracy: %f\n', acc_test);

[~, ~, pred] = supervised_dnn_cost( opt_params, ei, data_train, [], true);
[~,pred] = max(pred);
acc_train = mean(pred'==labels_train);
fprintf('train accuracy: %f\n', acc_train);
