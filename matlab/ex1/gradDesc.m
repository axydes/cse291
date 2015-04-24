function [ theta, losses ] = gradDesc( funObj, theta, maxIters, X, y, alpha )
%GRADDESC Performs gradient descent

fprintf('Iter\tLoss\n');
oldF = 9e99;
losses = zeros(maxIters,1);
for i=1:maxIters
    [f,g] = funObj(theta, X, y);
    theta = theta - g.*alpha;
    
    if mod(i,round(maxIters*.1)) == 0
        fprintf('%d\t%f\n',i,f);
    end
    
    if isnan(f) || isnan(g(1)) || f < 1
        break;
    end
    if f > oldF
        fprintf('Objective value increased, stopping.\n');
        break;
    end
    oldF = f;
    losses(i) = f;
end

theta = reshape(theta, size(X,1), size(y,1));

end

