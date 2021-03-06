load=false;
load=true;
if load
    close all; clear all;clc;
    addpath ../common
    addpath ../common/minFunc_2012/minFunc
    addpath ../common/minFunc_2012/minFunc/compiled

    % Load the MNIST data for this exercise.
    % train.X and test.X will contain the training and testing images.
    %   Each matrix has size [n,m] where:
    %      m is the number of examples.
    %      n is the number of pixels in each image.
    % train.y and test.y will contain the corresponding labels (0 to 9).
    binary_digits = false;
    num_classes = 10;
    [train,test] = ex1_load_mnist(binary_digits);

    % Add row of 1s to the dataset to act as an intercept term.
    train.X = [ones(1,size(train.X,2)); train.X]; 
    test.X = [ones(1,size(test.X,2)); test.X];
    train.y = train.y+1; % make labels 1-based.
    test.y = test.y+1; % make labels 1-based.

    newTrainY=zeros(10,numel(train.y));
    newTestY=zeros(10,numel(test.y));

    for i=1:numel(train.y)
        newTrainY(train.y(i),i) = 1;
    end
    for i=1:numel(test.y)
        newTestY(test.y(i),i) = 1;
    end

    % Training set info
    m=size(train.X,2);
    n=size(train.X,1);
end

learn=false;
learn=true;
if learn
    % Train softmax classifier using minFunc
    options = struct('MaxIter', 200);

    % Initialize theta.  We use a matrix where each column corresponds to a class,
    % and each row is a classifier coefficient for that class.
    % Inside minFunc, theta will be stretched out into a long vector (theta(:)).
    initTheta = rand(n,num_classes)*0.001;

    % Call minFunc with the softmax_regression.m file as objective.
    %
    % TODO:  Implement batch softmax regression in the softmax_regression.m
    % file using a vectorized implementation.
    %
    tic;
    theta=minFunc(@softmax_regression, initTheta(:), options, train.X, newTrainY);
    theta = reshape(theta, size(train.X,1), size(newTrainY,1));
    fprintf('Optimization of MinFunc took %f seconds.\n', toc);
%     checkTheta(theta(:,1));


    % TODO:  1) check the gradient calculated above using your checker code.
    %        2) Use stochastic gradient descent for this problem.
    %        *3) Use batch gradient descent.
    %        4) Plot speed of convergence for 2 (and 3) (loss function - # of iteration)
    %        5) Compute training time and accuracy of train & test data.

        % 1) grad check

        % 2) SGD
        tic;
        [thetaSGD,lossesSGD] = sgd(@softmax_regression, initTheta(:), 100, train.X, newTrainY, 1e-5, 0.05);
        fprintf('SGD took %f seconds.\n', toc);
%         checkTheta(thetaSGD(:,1));

        % 3) batch gradient descent
        tic;
        [thetaGrad,losses] = gradDesc(@softmax_regression, initTheta(:), 100, train.X, newTrainY, 1e-5);
        fprintf('Gradient descent took %f seconds.\n', toc);
%         checkTheta(thetaGrad(:,1));
end

thetaFig(theta,thetaSGD,thetaGrad,false);

% Example of printing out training/test accuracy.
accuracy = multi_classifier_accuracy(theta,train.X,train.y);
fprintf('minFunc Training accuracy: %2.1f%%\n', 100*accuracy);
accuracy = multi_classifier_accuracy(theta,test.X,test.y);
fprintf('minFunc Test accuracy: %2.1f%%\n', 100*accuracy);

figure;
plot(lossesSGD);
title('SGD Convergence');
xlabel('Iteration #');
ylabel('Loss');

accuracySGD = multi_classifier_accuracy(thetaSGD,train.X,train.y);
fprintf('SGD Training accuracy: %2.1f%%\n', 100*accuracySGD);
accuracySGD = multi_classifier_accuracy(thetaSGD,test.X,test.y);
fprintf('SGD Test accuracy: %2.1f%%\n', 100*accuracySGD);

figure;
plot(losses);
title('BGD Convergence');
xlabel('Iteration #');
ylabel('Loss');

accuracyGrad = multi_classifier_accuracy(thetaGrad,train.X,train.y);
fprintf('Gradient Descent Training accuracy: %2.1f%%\n', 100*accuracyGrad);
accuracyGrad = multi_classifier_accuracy(thetaGrad,test.X,test.y);
fprintf('Gradient Descent Test accuracy: %2.1f%%\n', 100*accuracyGrad);

