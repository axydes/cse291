function [ theta ] = sgd( theta, maxIters, X, y, lambda )
%GRADDESC Performs stochastic gradient descent
%   Detailed explanation goes here

oldSSE=9e99;
for i=1:maxIters
    for j=1:size(X,2) %# samples
        target = theta'*X(:,j);
        gradient = (y(j) - target) .* X(:,j);
        theta = theta + gradient.*lambda;
    end
    
    %objective error function: sum of squared errors
    sumSE = sse(theta, X, y);
    
    if sumSE > oldSSE
        fprintf('Objective value increased, stopping.\n');
        break;
    end
    oldSSE = sumSE;
    
%     lambda = lambda * 0.99;
end

end

