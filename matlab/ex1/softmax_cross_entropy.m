function [ err ] = softmax_cross_entropy( t, y )
%softmax_cross_entropy does the multiclass cross-entropy in vectorized
%manner

 first = t .* log(y);
 err = -sum(sum(first));

end

