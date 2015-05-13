function [ sinG, cosG ] = get_gabors(is_pofa)
%get_gabors get the 40 Gabor filters (8 orientations, 5 scales)

scale=64;
sinG = zeros(scale,scale,40);
cosG = zeros(scale,scale,40);

thetas=[0:(pi/8):(7*pi/8)];

for i=1:5
for j=1:8
    if is_pofa
        k = ((2*pi)/64) * (1.7^(i+2));
    else
        k = ((2*pi)/64) * (2^(i));
    end

    sinG(:,:,(i-1)*8+j) = ((imag(gabor(thetas(j), k, pi, scale))));
    cosG(:,:,(i-1)*8+j) = ((real(gabor(thetas(j), k, pi, scale))));

end
end

% Debug code
%     figure;
%     for j=1:40
%     subplot(5,8,j);
%     imshow(sinG(:,:,j));%/256);%/max(images(i,j,:,:)));
%     end

end