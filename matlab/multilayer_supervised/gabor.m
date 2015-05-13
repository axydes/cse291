function [ gm ] = gabor( theta, k, sigma, width )
%gabor Create a single gabor filter given scale, orientation, sigma, size

    start = -(width/2);
    stop = width/2;
    gm = ones(width,width)*0.5;
    for x=start:stop-1
        for y=start:stop-1
            first=exp(1i * (k * (cos(theta)*x + sin(theta)*y)));
            second=exp(-(k^2*(x^2+y^2))/(2*sigma^2));            
            gm(x+stop+1,y+stop+1) = first*second;
        end
    end

end

