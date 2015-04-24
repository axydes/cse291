function [ theta, losses ] = sgd( funObj, theta, maxIters, X, y, alpha, batchPerc )
%sgd Performs stochastic gradient descent

fprintf('Iter\tLoss\n');

oldLoss=9e99;
for i=1:maxIters    
    n = size(X,2); %# samples
    batchSize=round(n * batchPerc);
    for j=1:batchSize:n
        if j+batchSize < n
            [f,g] = funObj(theta, X(:,j:j+batchSize), y(:,j:j+batchSize));
        else
            [f,g] = funObj(theta, X(:,j:end), y(:,j:end));
        end
        
        theta = theta - g.*alpha;        
    end

    [f,g] = funObj(theta, X, y);
    if f > oldLoss
        fprintf('Objective value increased, stopping. %f, %f\n',f, oldLoss);
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

