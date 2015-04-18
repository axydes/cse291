function [ err ] = cross_entropy( t, y )
%CROSS_ENTROPY Summary of this function goes here
%   Detailed explanation goes here

 first = t * log(y);
 second = (1-t) * log(1-y);
 err = -sum(first + second);

end

