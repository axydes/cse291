function [ err ] = cross_entropy( t, y )
%CROSS_ENTROPY performs binary cross entropy in vectorized manner

 first = t * log(y);
 second = (1-t) * log(1-y);
 err = -sum(first + second);

end

