function [ theta ] = gradDesc( theta, maxIters, X, y, lambda )
%GRADDESC Summary of this function goes here
%   Detailed explanation goes here


for i=1:maxIters
    [f,g] = linear_regression(theta, X, y);
%     theta = theta .* 0.9;
    theta = theta - g.*lambda;
    
%     fprintf('%f\t%f\n',f,g);
    
    if isnan(f) || isnan(g(1)) || f < 1
        break;
    end
end

end

