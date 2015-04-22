function [ h ] = softmax( a )
%softmax calculates the softmax

    num = exp(a);    
    denom = sum(num,2);
    
    denom=repmat(denom,1,size(a,2));
    
    h = num./denom;
%     assert(abs(sum(h) - 1) < 1e-3);

end

