function [ theta, losses ] = sgd( funObj, theta, maxIters, X, y, lambda )
%GRADDESC Performs stochastic gradient descent
%   Detailed explanation goes here

fprintf('Iter\tLoss\n');

oldLoss=9e99;
losses = zeros(maxIters,1);
for i=1:maxIters
    for j=1:size(X,2) %# samples
        [f,g] = funObj(theta, X(:,j), y(:,j));
        
%         g(g > 1e-4) = 1e-4;
%         g(g < -1e-4) = -1e-4;
        
        theta = theta - g.*lambda;
%         theta = theta * 0.99;
        
    end

%     if abs(f-oldLoss) < 1e-6
%         fprintf('Objective value increased, stopping.\n');
%         break;
%     end
    [f,g] = funObj(theta, X, y);
%     accuracy = multi_classifier_accuracy(theta,X,y);
    fprintf('%d\t%f\n',i,f);
    
    oldLoss = f;
    losses(i) = f;
    
    
%     if mod(i,round(maxIters*.1)) == 0
%         fprintf('%d\t%f\n',i,f);
%     end
    
%     lambda = lambda * 0.99;
end

theta = reshape(theta, size(X,1), size(y,1));

end

