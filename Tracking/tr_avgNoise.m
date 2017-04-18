function [ pedestalImg, noiseImg ] = tr_avgNoise( img )
%% TR_AVGNOISE Analyze a stack of noise images and returns pedestal and noise
%  img is a 3d array composed of a stack of noise images (laser off). The
%  function  averages along Z (stack direction) and returns two 2D arrays:
%  -pedestalImg is the average value of each pixel
%  -noiseImg is the sigma of the mean for each pixel

    pedestalImg = mean(img, 3);
    
    noiseImg= std(single(img), 0, 3);
    
end

