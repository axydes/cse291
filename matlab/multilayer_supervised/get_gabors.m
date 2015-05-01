function [ sinG, cosG ] = get_gabors()

sinG = zeros(96,96,40);
cosG = zeros(96,96,40);

thetas=[0:(pi/8):(7*pi/8)];

for i=1:5
for j=1:8
    k = ((2*pi)/64) * (1.5^i);

    sinG(:,:,(i-1)*8+j) = ((imag(gabor(thetas(j), k, pi, 96))));
    cosG(:,:,(i-1)*8+j) = ((real(gabor(thetas(j), k, pi, 96))));

end
end

end