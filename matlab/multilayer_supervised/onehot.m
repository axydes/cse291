function [ mat ] = onehot( idx, maxNum )
%onehot Create a vector (maxNum in length), set idx value to 1

    mat=zeros(length(idx),maxNum);
    for i=1:length(idx)
        mat(i,idx(i))=1;
    end

end

