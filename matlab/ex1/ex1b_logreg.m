
addpath ../common
addpath ../common/minFunc_2012/minFunc
addpath ../common/minFunc_2012/minFunc/compiled

learning = false;
learning = true;
if learning
    close all;clear all;clc;
    
    % Load the MNIST data for this exercise.
    % train.X and test.X will contain the training and testing images.
    %   Each matrix has size [n,m] where:
    %      m is the number of examples.
    %      n is the number of pixels in each image.
    % train.y and test.y will contain the corresponding labels (0 or 1).
    binary_digits = true;
    [train,test] = ex1_load_mnist(binary_digits);

    % Add row of 1s to the dataset to act as an intercept term.
    train.X = [ones(1,size(train.X,2)); train.X]; 
    test.X = [ones(1,size(test.X,2)); test.X];

    % Training set dimensions
    m=size(train.X,2);
    n=size(train.X,1);

    % Train logistic regression classifier using minFunc
    options = struct('MaxIter', 100);

    % First, we initialize theta to some small random values.
    initTheta = rand(n,1)*0.001;

    % Call minFunc with the logistic_regression.m file as the objective function.
    %
    % TODO:  Implement batch logistic regression in the logistic_regression.m
    % file! Remember to use MATLAB's vectorization features to speed up your code.
    %
    tic;
    theta=minFunc(@logistic_regression, initTheta, options, train.X, train.y);
    fprintf('Optimization of MinFunc took %f seconds.\n', toc);
%     checkTheta(theta);


    % TODO:  1) Write your own gradient check code and check the gradient
    %           calculated above.
    %        2) Use stochastic gradient descent for this problem.
    %        *3) Use batch gradient descent.
    %        4) Plot speed of convergence for 2 (and 3) (loss function - # of iteration)
    %        5) Compute training time and accuracy of train & test data.

    % 1) grad check
    
    % 2) SGD
    tic;
    [thetaSGD,lossesSGD] = sgd(@logistic_regression, initTheta, 50, train.X, train.y, 5e-9);
    fprintf('SGD took %f seconds.\n', toc);
%     checkTheta(thetaSGD);

    % 3) batch gradient descent
    tic;
    [thetaGrad,losses] = gradDesc(@logistic_regression, initTheta, 1000, train.X, train.y, 5e-9);
    fprintf('Gradient descent took %f seconds.\n', toc);
%     checkTheta(thetaGrad);

end

thetaFig(theta,thetaSGD,thetaGrad,true);

% Example of printing out training/test accuracy.
accuracy = binary_classifier_accuracy(theta,train.X,train.y);
fprintf('minFunc Training accuracy: %2.1f%%\n', 100*accuracy);
accuracy = binary_classifier_accuracy(theta,test.X,test.y);
fprintf('minFunc Test accuracy: %2.1f%%\n', 100*accuracy);

figure;
plot(lossesSGD);
title('SGD Convergence');
xlabel('Iteration #');
ylabel('Loss');

accuracySGD = binary_classifier_accuracy(thetaSGD,train.X,train.y);
fprintf('SGD Training accuracy: %2.1f%%\n', 100*accuracySGD);
accuracySGD = binary_classifier_accuracy(thetaSGD,test.X,test.y);
fprintf('SGD Test accuracy: %2.1f%%\n', 100*accuracySGD);

figure;
plot(losses);
title('BGD Convergence');
xlabel('Iteration #');
ylabel('Loss');

accuracyGrad = binary_classifier_accuracy(thetaGrad,train.X,train.y);
fprintf('Gradient descent Training accuracy: %2.1f%%\n', 100*accuracyGrad);
accuracyGrad = binary_classifier_accuracy(thetaGrad,test.X,test.y);
fprintf('Gradient descent Test accuracy: %2.1f%%\n', 100*accuracyGrad);

