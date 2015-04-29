function [ images ] = zscoreImgs( images )
%zscore Summary of this function goes here
%   Detailed explanation goes here

    for i=1%:size(images,1)
        for j=1:40
            immean = mean(images{i,j}(:));
            imstd = std(images{i,j}(:));
            images{i,j} = (images{i,j} - immean) ./imstd;
        end        
    end
    
    figure;
    for j=1:40
    subplot(8,5,j);
    imshow(images{i,j});
    end

end

