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
    [sinG,cosG]=get_gabors(true);
    [pofas,~]=load_images(true);
    [conns,fullConns] = convolveImages(pofas,sinG,cosG);
    zscored=zscoreImgs(conns);
    reducedNims=reducedDims(zscored,true);

%     plot gabor filters
    figure;
    for j=1:40
    subplot(6,8,j);
    imshow(sinG(:,:,j),[]);
    end
    for j=1:8
        subplot(6,8,40+j);
        imshow(pofas{j,2},[]);
    end

%     Debugging code
    figure;
    for j=1:40
    subplot(5,8,j);
    imshow(zscored(:,:,j,1)/max(max(zscored(:,:,j,1))));
    end
    figure;
    imshow(reducedNims);

%     Save preprocessed data to reduce startup time
    fname='/home/axydes/Documents/MATLAB/pofas_preproc3.mat';
    save(fname,'sinG','cosG','pofas','conns','fullConns','reducedNims');
else
    load('pofas_preproc2.mat');
end

for iter=14
    fprintf('Test Actor: %d\n',iter);

[data_train,labels_train,data_test,labels_test,data_val,labels_val,maxID,...
    maxLabel, testActor,valActor] =separatePofaData(pofas,reducedNims,iter);


%% populate ei with the network architecture to train
% ei is a structure you can use to store hyperparameters of the network
% You should be able to try different network architectures by changing ei
% only (no changes to the objective function code)


%TODO: decide proper hyperparameters.
% dimension of input features FOR YOU TO DECIDE
ei.input_dim = size(data_train,2);
% number of output classes FOR YOU TO DECIDE
ei.output_dim = 6;
% sizes of all hidden layers and the output layer FOR YOU TO DECIDE
ei.layer_sizes = [20, ei.output_dim];
% scaling parameter for l2 weight regularization penalty
ei.lambda = 1e-2; %1e-2 for minFunc, 1e-3 for sgd?
% momentum term
ei.mu = 0.01;%0.001 for minFunc, 0.01 for sgd?
% learning rate
ei.alpha = 1e-3;
% which type of activation function to use in hidden layers
% feel free to implement support for different activation function
ei.activation_fun = 'tanh';

maxIters=10000;

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
% minFunc code
    data_train = vertcat(data_train,data_val);
    labels_train = vertcat(labels_train,labels_val);
    [opt_params,opt_value,exitflag,output] = minFunc(@supervised_dnn_cost,...
        params,options,ei, data_train, onehot(labels_train,maxLabel));
    mfTimes(iter)=toc;
    fprintf('minFunc took %f seconds.\n',mfTimes(iter));
else
% SGD code
    [opt_params, sgdLosses, stop_points(iter)] = sgd_nn(@supervised_dnn_cost, params, maxIters, data_train,...
        onehot(labels_train,maxLabel), ei, 1, data_val, onehot(labels_val,maxLabel));
    sgdTimes(iter)=toc;
    fprintf('SGD took %f seconds.\n',sgdTimes(iter));
end

% TODO:  1) check the gradient calculated by supervised_dnn_cost.m
% grad_check(@supervised_dnn_cost, params, 50, ei, data_train, onehot(labels_train,newmaxID), false);
%        2) Decide proper hyperparamters and train the network.
%        3) Implement SGD version of solution.
%        4) Plot speed of convergence for 1 and 3.
%        5) Compute training time and accuracy of train & test data.

finalStack = params2stack(opt_params, ei);

%% compute accuracy on the test and train set
if ~use_mf
    [val_loss(iter), ~, predo] = supervised_dnn_cost( opt_params, ei, data_val, onehot(labels_val,maxLabel), true);
    [~,pred] = max(predo);
    pred=pred';
    acc_val(iter) = mean(pred==labels_val);
    fprintf('val actor: %d, accuracy: %f, loss: %f\n', valActor, acc_val(iter), val_loss(iter));
end

[test_loss(iter), ~, predo] = supervised_dnn_cost( opt_params, ei, data_test, onehot(labels_test,maxLabel), true);
[~,pred] = max(predo);
pred=pred';
acc_test(iter) = mean(pred==labels_test);
fprintf('test actor: %d, accuracy: %f, loss: %f\n', testActor, acc_test(iter), test_loss(iter));

[~, ~, pred] = supervised_dnn_cost( opt_params, ei, data_train, onehot(labels_train,maxLabel), true);
[~,pred] = max(pred);
pred=pred';
acc_train(iter) = mean(pred==labels_train);
fprintf('train accuracy: %f\n', acc_train(iter));
end

%Display some timing and accuracy info
if ~use_mf
    mean(sgdTimes)
    mean(acc_val)
end
mean(acc_test)
mean(acc_train)
acc_test

if use_mf
    %Plot minFunc accuracy
    figure;
    bar(acc_test);%for minFunc
    title('POFA minFunc Test Accuracy');
    ylabel('Percent Correct');
    xlabel('Test Actor');

    % Plot minFunc convergence
    figure;
    plot(output.trace.fval);
    title('POFA minFunc Training Loss');
    xlabel('Iteration');
    ylabel('Loss');
    
    save('minFunc_exp_crossval.mat','acc_val','acc_test','acc_train','val_loss','test_loss','ei');
else
    % Plot SGD accuracy
    figure;
    temp=vertcat(acc_train,acc_val,acc_test);
    bar([temp(1,:)',temp(2,:)',temp(3,:)']);%for sgd
    title('POFA SGD Test Accuracy');
    ylabel('Percent Correct');
    xlabel('Test Actor');

    %Plot SGD convergence
    figure;
    plot(sgdLosses(100:100:end));
    title('POFA SGD Training Loss');
    xlabel('Iteration');
    ylabel('Loss');
    ax = gca;
    set(ax,'XTickLabel',[100:100:900]);
    
    save('sgd_exp_crossval2.mat','sgdLosses','acc_val','acc_test','acc_train','val_loss','test_loss','ei','sgdTimes','stop_points');
end
