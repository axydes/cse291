function [ conns, fullConns ] = convolveImages( images, sinG, cosG )
%convolveImages convolve the 40 Gabor filters with all the images

    outWidth=12;
    n=size(images,1);
    conns=zeros(outWidth,outWidth,40,n);
    for i=1:n
        disp(i);
        imWidth=size(images{i,2},1);
        start = size(sinG,1)+1;
        stop = start+imWidth-1;
        im = zeros(stop+start-1,stop+start-1,1);
        im(start:stop,start:stop) = images{i,2}(:,:);

        for j=1:40
            tempConSin=conv2(im, sinG(:,:,j), 'valid');
            tempConCos=conv2(im, cosG(:,:,j), 'valid');

            tempCon = sqrt(tempConSin.^2 + tempConCos.^2);

            m=size(tempCon,1);
            mstart=round((m-imWidth)/2);
            mstop=mstart+imWidth;

            tempCon = tempCon(mstart:mstop,mstart:mstop);
            fullConns{i,j} = tempCon;

            ds = imresize(tempCon,[outWidth,outWidth],'cubic');
            conns(:,:,j,i) = ds;
        end
    end

% Debug code
%     figure;
%     for j=1:40
%     subplot(5,8,j);
%     imshow(conns(:,:,j)/256);%/max(images(i,j,:,:)));
%     end

end

