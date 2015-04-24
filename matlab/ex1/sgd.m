function [ theta, losses ] = sgd( funObj, theta, maxIters, X, y, lambda )
%GRADDESC Performs stochastic gradient descent
%   Detailed explanation goes here

fprintf('Iter\tLoss\n');

oldLoss=9e99;
losses = zeros(maxIters,1);
for i=1:maxIters    
    for j=1:size(X,2) %# samples
        [f,g] = funObj(theta, X(:,j), y(:,j));
        
        theta = theta - g.*lambda;
    end

    [f,g] = funObj(theta, X, y);    
    oldLoss = f;
    losses(i) = f;
    
    if mod(i,round(maxIters*.1)) == 0        
        fprintf('%d\t%f\n',i,f);
    end
end

theta = reshape(theta, size(X,1), size(y,1));

end

