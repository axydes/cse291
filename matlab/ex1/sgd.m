function [ theta, losses ] = sgd( funObj, theta, maxIters, X, y, lambda )
%GRADDESC Performs stochastic gradient descent
%   Detailed explanation goes here

fprintf('Iter\tLoss\n');

oldLoss=9e99;
losses = zeros(maxIters,1);
for i=1:maxIters
    for j=1:size(X,2) %# samples
%         target = theta'*X(:,j);
%         gradient = (y(j) - target) .* X(:,j);
        [f,g] = funObj(theta, X(:,j), y(j));
        theta = theta - g.*lambda;
    end

    if abs(f-oldLoss) < 1e-6
        fprintf('Objective value increased, stopping.\n');
        break;
    end
    oldLoss = f;
    losses(i) = f;
    
    if mod(i,round(maxIters*.1)) == 0
        fprintf('%d\t%f\n',i,f);
    end
    
%     lambda = lambda * 0.99;
end

end

