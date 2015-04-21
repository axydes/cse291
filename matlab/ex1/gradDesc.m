function [ theta ] = gradDesc( funObj, theta, maxIters, X, y, lambda )
%GRADDESC Performs gradient descent
%   Detailed explanation goes here

oldF = 9e99;
for i=1:maxIters
    [f,g] = funObj(theta, X, y);
    theta = theta - g.*lambda;
    
    if isnan(f) || isnan(g(1)) || f < 1
        break;
    end
    if f > oldF
        fprintf('Objective value increased, stopping.\n');
        break;
    end
    oldF = f;
end

end

