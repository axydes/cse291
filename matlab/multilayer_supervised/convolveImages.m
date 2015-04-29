function [ conns, fullConns ] = convolveImages( images, sinG, cosG )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    for i=1%:size(images,1)
        imWidth=size(images{i,2},1);
        start = size(sinG,1)+1;
        stop = start+imWidth-1;
        im = zeros(stop+start-1,stop+start-1,1);
        im(start:stop,start:stop) = images{i,2}(:,:);

        for j=1:40
            tempConSin=conv2(im, sinG(:,:,j), 'valid');
            tempConCos=conv2(im, cosG(:,:,j), 'valid');

            tempCon = sqrt(tempConSin.^2 + tempConCos.^2);

    %         tempCon = tempCon / max(tempCon(:));

            m=size(tempCon,1);
            mstart=round((m-imWidth)/2);
            mstop=mstart+imWidth;

            tempCon = tempCon(mstart:mstop,mstart:mstop);
            fullConns{i,j} = tempCon;

            ds = imresize(tempCon,[8,8],'cubic');
            conns{i,j} = ds;
        end
    end

    figure;
    for j=1:40
    subplot(8,5,j);
    imshow(conns{i,j}/max(conns{i,j}(:)));
    end

end

