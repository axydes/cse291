function [ theta, losses ] = sgd_nn( funObj, theta, maxIters, X, y, ei, batchSize )
%sgd Performs stochastic gradient descent

fprintf('Iter\tLoss\n');
alpha=ei.alpha;

oldLoss=9e99;
for i=1:maxIters    
    n = size(X,2); %# samples
    for j=1:batchSize:n
        if j+batchSize < n
            [f,g] = funObj(theta, ei, X(j:j+batchSize,:), y(j:j+batchSize,:), false);
        else
            [f,g] = funObj(theta, ei, X(j:end,:), y(j:end,:), false);
        end
        
        theta = theta - g.*alpha;        
    end

    [f,g] = funObj(theta, ei, X, y, false);
    if f > oldLoss
%         fprintf('Objective value increased, stopping. %f, %f\n',f, oldLoss);
%         break;
    end
    oldLoss = f;
    losses(i) = f;
    
    if mod(i,round(maxIters*.1)) == 0        
        fprintf('%d\t%f\n',i,f);
    end
end

% theta = reshape(theta, size(X,1), size(y,1));

end

