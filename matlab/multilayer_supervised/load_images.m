function [ pofaImgs, nimImgs ] = load_images(is_pofas)
%load_images Load images, do a little preprocessing (grayscale, rescale)

    imWidth=64;

    if is_pofas
        pofaDir = '/home/axydes/Documents/MATLAB/POFA/';
        pofaNames = dir(pofaDir);
        pofaNames=pofaNames(3:end);
        n=numel(pofaNames);
        for i=1:n
            curName = pofaNames(i).name;
            if strcmp(curName,'.') == 0 && strcmp(curName,'..') == 0
                fullName = strcat(pofaDir,curName);
                pofaImgs{i,1} = curName;
                rs = double(imresize(imread(fullName,'pgm'),[imWidth,imWidth]));

                rs = rs - mean2(rs);
                rs = rs ./ max(abs(rs(:)));

                pofaImgs{i,2} = rs;
            end
        end
        pofaImgs=parseNames(pofaImgs,false);
        nimImgs=pofaImgs;
    else    
        nimDir = '/home/axydes/Documents/MATLAB/NimStim/';
        nimNames = dir(nimDir);
        nimNames=nimNames(3:end);
        n=numel(nimNames);
        for i=1:n
            curName = nimNames(i).name;
            if strcmp(curName,'.') == 0 && strcmp(curName,'..') == 0
                fullName = strcat(nimDir,curName);
                nimImgs{i,1} = curName;
                grayed=rgb2gray(imread(fullName,'BMP'));
                height = size(grayed,1);
                width = size(grayed,2);
                cropped = grayed(round(height/4):round(5*height/6),round(width/5):round(4*width/5));
                rs = double(imresize(cropped,[imWidth,imWidth]));

                rs = rs - mean2(rs);
                rs = rs ./ max(abs(rs(:)));

                nimImgs{i,2} = rs;
            end
        end    
        nimImgs=parseNames(nimImgs,true);
        pofaImgs=nimImgs;
    end

end

