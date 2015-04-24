function [ theta, losses ] = sgd( funObj, theta, maxIters, X, y, alpha )
%sgd Performs stochastic gradient descent

fprintf('Iter\tLoss\n');

oldLoss=9e99;
for i=1:maxIters    
    for j=1:size(X,2) %# samples
        [f,g] = funObj(theta, X(:,j), y(:,j));
        
        theta = theta - g.*alpha;
    end

    [f,g] = funObj(theta, X, y);
    if f > oldLoss
        fprintf('Objective value increased, stopping.\n');
        break;
    end
    oldLoss = f;
    losses(i) = f;
    
    if mod(i,round(maxIters*.1)) == 0        
        fprintf('%d\t%f\n',i,f);
    end
end

theta = reshape(theta, size(X,1), size(y,1));

end

