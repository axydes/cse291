function [ images ] = zscoreImgs( images )
%zscore Summary of this function goes here
%   Detailed explanation goes here

    for i=1:size(images,1)
        for j=1:40
            immean = mean(mean(images(:,:,j,i)));
            imstd = std(std(images(:,:,j,i)));
            images(:,:,j,i) = (images(:,:,j,i) - immean) ./imstd;
        end        
    end
    
%     figure;
%     for j=1:40
%     subplot(5,8,j);
%     imshow(images(:,:,j,i));
%     end

end

