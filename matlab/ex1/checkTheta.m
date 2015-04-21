function [ ] = checkTheta( theta )
%CHECKTHETA Summary of this function goes here
%   Detailed explanation goes here

    %remove bias
    th = theta(2:end);
    n=round(sqrt(size(theta,1)));
    thetaPx = reshape(th, n, n);
    
    figure;
    imshow(mat2gray(thetaPx));

end

