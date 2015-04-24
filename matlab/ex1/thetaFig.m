function [  ] = thetaFig( thetaMF, thetaSGD, thetaGrad, binary )
%thetaFig Creates a figure of some of the parameters learned for each
%technique
%   For binary classification: weights for 0,1 digits. For multiclass 
%   classification: weights for 0,1, and 3 digits

numCols=3;
if binary
    numCols=1;
end

figure;
subplot(3,numCols,1);
imshow(grayscaleTheta(thetaMF(:,1)));
ylabel('minFunc');
subplot(3,numCols,1+numCols);
imshow(grayscaleTheta(thetaSGD(:,1)));
ylabel('SGD');
subplot(3,numCols,1+numCols*2);
imshow(grayscaleTheta(thetaGrad(:,1)));
ylabel('BGD');


if ~binary
    xlabel('0');
    subplot(3,numCols,2);
    imshow(grayscaleTheta(thetaMF(:,2)));
    subplot(3,numCols,2+numCols);
    imshow(grayscaleTheta(thetaSGD(:,2)));
    subplot(3,numCols,2+numCols*2);
    imshow(grayscaleTheta(thetaGrad(:,2)));
    xlabel('1');    

    subplot(3,numCols,3);
    imshow(grayscaleTheta(thetaMF(:,4)));
    subplot(3,numCols,3+numCols);
    imshow(grayscaleTheta(thetaSGD(:,4)));
    subplot(3,numCols,3+numCols*2);
    imshow(grayscaleTheta(thetaGrad(:,4)));
    xlabel('3');
end

end

