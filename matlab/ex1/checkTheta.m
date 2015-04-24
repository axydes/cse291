function [ ] = checkTheta( theta )
%CHECKTHETA Used to debug weights while developing

    %remove bias
    th = theta(2:end);
    n=round(sqrt(size(theta,1)));
    thetaPx = reshape(th, n, n);
    
    figure;
    imshow(mat2gray(thetaPx));

end

