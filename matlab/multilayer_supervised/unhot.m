function [ out ] = unhot( vec, min )
%unhot go from onehot vector to single integer

    [val,idx]=max(vec);
    out=idx+min-1;

end

