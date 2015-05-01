function [ mat ] = onehot( idx, maxNum )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

    mat=zeros(length(idx),maxNum);
    for i=1:length(idx)
        mat(i,idx(i))=1;
    end

end

