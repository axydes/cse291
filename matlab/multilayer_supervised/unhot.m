function [ out ] = unhot( vec, min )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

    [val,idx]=max(vec);
    out=idx+min-1;

end

