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

use_mf=false;
% use_mf=true;

do_preproc=false;
% do_preproc=true;

%% Image preprocessing
if do_preproc
    [sinG,cosG]=get_gabors(false);
    [~,nims]=load_images(false);
    [conns,fullConns] = convolveImages(nims,sinG,cosG);
    zscored=zscoreImgs(conns);
    reducedNims=reducedDims(zscored,false);

    % plot gabor filters
    figure;
    for j=1:40
    subplot(6,8,j);
    imshow(sinG(:,:,j),[]);
    end
    for j=1:8
        subplot(6,8,40+j);
        imshow(nims{j,2},[]);
    end

    % Debugging code
    figure;
    for j=1:40
    subplot(5,8,j);
    imshow(zscored(:,:,j,1)/max(max(zscored(:,:,j,1))));
    end
    imshow(reducedNims);

    % Save preprocessed data to reduce startup time
    fname='/home/axydes/Documents/MATLAB/nims_preproc3.mat';
    save(fname,'sinG','cosG','nims','conns','fullConns','reducedNims');
else
    load('nims_preproc.mat');
end

clear acc_test
clear acc_train

for i=1%:25

[data_train,labels_train,data_test,labels_test,minID,maxID,newmaxID,newminID]=separateData(nims,reducedNims);


%% populate ei with the network architecture to train
% ei is a structure you can use to store hyperparameters of the network
% You should be able to try different network architectures by changing ei
% only (no changes to the objective function code)


%TODO: decide proper hyperparameters.
% dimension of input features FOR YOU TO DECIDE
ei.input_dim = 40;
% number of output classes FOR YOU TO DECIDE
ei.output_dim = 22;
% sizes of all hidden layers and the output layer FOR YOU TO DECIDE
ei.layer_sizes = [100, ei.output_dim];
% scaling parameter for l2 weight regularization penalty
ei.lambda = 1e-1;
% momentum term
ei.mu = 0.01;
% learning rate
ei.alpha = 1e-2;
% which type of activation function to use in hidden layers
% feel free to implement support for different activation function
ei.activation_fun = 'tanh';

maxIters=100;

%% setup random initial weights
stack = initialize_weights(ei);
params = stack2params(stack);

%% setup minfunc options
options = [];
options.display = 'final';
options.maxFunEvals = 1e9;
options.Method = 'lbfgs';

%% run training
        
% For minFunc momentum
clear supervised_dnn_cost;

tic;

if use_mf
    [opt_params,opt_value,exitflag,output] = minFunc(@supervised_dnn_cost,...
        params,options,ei, data_train, onehot(labels_train,newmaxID), false);
    mfTimes(i)=toc;
    fprintf('minFunc took %f seconds.\n',mfTimes(i));
else
    [opt_params, sgdLosses, stop_points(i)] = sgd_nn(@supervised_dnn_cost, params, maxIters, data_train,...
        onehot(labels_train,newmaxID), ei, 1);
    sgdTimes(i)=toc;
    fprintf('SGD took %f seconds.\n',sgdTimes(i));
end

% TODO:  1) check the gradient calculated by supervised_dnn_cost.m
% grad_check(@supervised_dnn_cost, params, 50, ei, data_train, onehot(labels_train,newmaxID), false);
%        2) Decide proper hyperparamters and train the network.
%        3) Implement SGD version of solution.
%        4) Plot speed of convergence for 1 and 3.
%        5) Compute training time and accuracy of train & test data.

finalStack = params2stack(opt_params, ei);

%% compute accuracy on the test and train set
[~, ~, predo] = supervised_dnn_cost( opt_params, ei, data_test, onehot(labels_test,newmaxID), true);
[~,pred] = max(predo);
pred=pred';
acc_test(i) = mean(pred==labels_test);
fprintf('test accuracy: %f\n', acc_test(i));

[~, ~, pred] = supervised_dnn_cost( opt_params, ei, data_train, onehot(labels_train,newmaxID), true);
[~,pred] = max(pred);
pred=pred';
acc_train(i) = mean(pred==labels_train);
fprintf('train accuracy: %f\n', acc_train(i));

end

%% Plot results
mean(acc_test)
std(acc_test)

if use_mf
    %Plot minFunc convergence
    figure;
    plot(output.trace.fval);
    title('NimStim minFunc Training Loss');
    xlabel('Iteration');
    ylabel('Loss');
    save('minFunc_ident_crossval2.mat','acc_test','acc_train','ei');
else
    %Plot SGD convergence
    figure;
    plot(sgdLosses(10:10:end));
    title('NimStim SGD Training Loss');
    xlabel('Iteration');
    ylabel('Loss');
    ax = gca;
    set(ax,'XTickLabel',[10:10:100]);
    save('sgd_ident_crossval2.mat','sgdLosses','acc_test','acc_train','ei','sgdTimes');
end

