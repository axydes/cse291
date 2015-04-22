function [ err ] = softmax_cross_entropy( t, y )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

 first = t .* log(y);
 err = -sum(sum(first));

end

