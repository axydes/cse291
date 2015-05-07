function [ zscored ] = reducedDims( images )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    n=size(images,4);
    imWidth=size(images,1)*size(images,2);
    reduced=zeros(n,8*imWidth,5);

    %Reduce each scale to a vector
    for i=1:n        
        for k=1:8
            for j=1:5
                temp=images(:,:,j,i);
                reduced(i,(k-1)*imWidth+1:(k*imWidth),j) = temp(:)';
            end
        end
    end
    
    %PCA
    for j=1:5
        tempmat=reduced(:,:,j)';
        size(tempmat);
        cvar=cov(tempmat);
        [V(:,:,j),D]=eigs(cvar,8);
    end
    
    %Concantenate
    for j=1:5
        ccd(:,(j-1)*8+1:(j*8))=V(:,:,j);
    end
        
    %zscore
    colStd=std(ccd);
    stds=repmat(colStd,n,1);
    zscored=ccd./stds;
    
end

