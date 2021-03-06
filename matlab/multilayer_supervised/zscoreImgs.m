function [ images ] = zscoreImgs( images )
%zscore zscore the images (subtract mean, divide std)

% Debug code
%     figure;
%     for j=1:40
%     subplot(5,8,j);
%     imshow(images(:,:,j,1));
%     end

    for i=1:size(images,1)
        for j=1:40
            immean = mean(mean(images(:,:,j,i)));
            imstd = std(std(images(:,:,j,i)));
            images(:,:,j,i) = (images(:,:,j,i) - immean) ./imstd;
        end        
    end
 
% Debug code
%     figure;
%     for j=1:40
%     subplot(5,8,j);
%     imshow(images(:,:,j,1)/max(max(images(:,:,j,1))));
%     end

end

