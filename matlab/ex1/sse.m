function [ sse ] = sse( theta, X, y )
%SSE Sum of squared errors

    predY = X' * theta;
    errs = predY - y';
    se = errs.^2;
    sse = sum(se);

end

