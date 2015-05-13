function [ zscored ] = reducedDims( images, is_pofa )
%reducedDims PCA and zscore images
    
    n=size(images,4);
    imWidth=size(images,1)*size(images,2);
    reduced=zeros(n,8*imWidth,5);
    if is_pofa
        num_comps=16;
    else
        num_comps=8;
    end        

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
        [V(:,:,j),D]=eigs(cvar,num_comps);
    end
    
    %Concantenate
    for j=1:5
        ccd(:,(j-1)*num_comps+1:(j*num_comps))=V(:,:,j);
    end
        
    %zscore
    colStd=std(ccd);
    stds=repmat(colStd,n,1);
    zscored=ccd./stds;
    
end

