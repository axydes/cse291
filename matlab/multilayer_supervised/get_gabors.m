function [ sinG, cosG ] = get_gabors()

scale=96;
sinG = zeros(scale,scale,40);
cosG = zeros(scale,scale,40);

thetas=[0:(pi/8):(7*pi/8)];

for i=1:5
for j=1:8
    k = ((2*pi)/64) * (2^(i));

    sinG(:,:,(i-1)*8+j) = ((imag(gabor(thetas(j), k, pi, scale))));
    cosG(:,:,(i-1)*8+j) = ((real(gabor(thetas(j), k, pi, scale))));

end
end

%     figure;
%     for j=1:40
%     subplot(5,8,j);
%     imshow(sinG(:,:,j));%/256);%/max(images(i,j,:,:)));
%     end


end