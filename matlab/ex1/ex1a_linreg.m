%
%This exercise uses a data from the UCI repository:
% Bache, K. & Lichman, M. (2013). UCI Machine Learning Repository
% http://archive.ics.uci.edu/ml
% Irvine, CA: University of California, School of Information and Computer Science.
%
%Data created by:
% Harrison, D. and Rubinfeld, D.L.
% ''Hedonic prices and the demand for clean air''
% J. Environ. Economics & Management, vol.5, 81-102, 1978.
%
addpath ../common
addpath ../common/minFunc_2012/minFunc
addpath ../common/minFunc_2012/minFunc/compiled

do_learn=true;
if do_learn
    % Load housing data from file.
    data = load('housing.data');
    data=data'; % put examples in columns

    % Include a row of 1s as an additional intercept feature.
    data = [ ones(1,size(data,2)); data ];

    % Shuffle examples.
    data = data(:, randperm(size(data,2)));

    % Split into train and test sets
    % The last row of 'data' is the median home price.
    train.X = data(1:end-1,1:400);
    train.y = data(end,1:400);

    test.X = data(1:end-1,401:end);
    test.y = data(end,401:end);

    m=size(train.X,2);
    n=size(train.X,1);

    % Initialize the coefficient vector theta to random values.
    initTheta = rand(n,1);

    % Run the minFunc optimizer with linear_regression.m as the objective.
    %
    % TODO:  Implement the linear regression objective and gradient computations
    % in linear_regression.m
    %
    tic;
    options = struct('MaxIter', 200);
    thetaMF = minFunc(@linear_regression, initTheta, options, train.X, train.y);
    fprintf('Optimization of MinFunc took %f seconds.\n', toc);


    % TODO:  Use 1) gradient descent 2)closed-form solution
    % for this problem. Compare all three of the solutions by RMS, and plot
    % all three predictions on test data.
    %
    tic;
    thetaGrad = gradDesc(initTheta, 1000000, train.X, train.y, 5e-9);
    fprintf('Gradient descent took %f seconds.\n', toc);

    tic;
    thetaClosed = closed(train.X, train.y);
    fprintf('Closed form took %f seconds.\n', toc);
end

%% Below is an example of error calculation and plotting for one solution.%%

% Plot predicted prices and actual prices from training set.
actual_prices = train.y;
predictedMF_prices = thetaMF'*train.X;
predictedGrad_prices = thetaGrad'*train.X;
predictedClosed_prices = thetaClosed'*train.X;

% Print out root-mean-squared (RMS) training error.
trainMF_rms=sqrt(mean((predictedMF_prices - actual_prices).^2));
trainGrad_rms=sqrt(mean((predictedGrad_prices - actual_prices).^2));
trainClosed_rms=sqrt(mean((predictedClosed_prices - actual_prices).^2));
fprintf('RMS training error:\n minFunc: %f, gradient descent: %f, closed form: %f\n',...
    trainMF_rms, trainGrad_rms, trainClosed_rms);

% Print out test RMS error
actual_prices = test.y;
predictedMF_prices = thetaMF'*test.X;
predictedGrad_prices = thetaGrad'*test.X;
predictedClosed_prices = thetaClosed'*test.X;
testMF_rms=sqrt(mean((predictedMF_prices - actual_prices).^2));
testGrad_rms=sqrt(mean((predictedGrad_prices - actual_prices).^2));
testClosed_rms=sqrt(mean((predictedClosed_prices - actual_prices).^2));
fprintf('RMS testing error:\n minFunc: %f, gradient descent: %f, closed form: %f\n',...
    testMF_rms, testGrad_rms, testClosed_rms);


% Plot predictions on test data.
plot_prices=true;
if (plot_prices)
  [actual_prices,I] = sort(actual_prices);
  predictedMF_prices=predictedMF_prices(I);
  predictedGrad_prices=predictedGrad_prices(I);
  predictedClosed_prices=predictedClosed_prices(I);
  plot(actual_prices, 'rx');
  hold on;
  plot(predictedMF_prices,'bx');
  plot(predictedGrad_prices,'gx');
  plot(predictedClosed_prices,'ko');
  legend('Actual Price', 'Predicted Price (minFunc)',...
      'Predicted Price (gradient descent)', 'Predicted Price (closed form)',...
      'Location','northwest');
  xlabel('House #');
  ylabel('House price ($1000s)');
  title('Actual and Predicted prices');
end

