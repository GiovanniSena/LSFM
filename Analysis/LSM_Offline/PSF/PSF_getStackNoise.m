function [ avgNoise,  stdNoise ] = PSF_getStackNoise( myImage, x, y, window  )
%GETSTACKNOISE Summary of this function goes here
%   Detailed explanation goes here
    
    if mod(window,2) ~= 0
        window= window-1;
    end
        
    xmin= x- window/2;
    xmax= x+ window/2;
    ymin= y- window/2;
    ymax= y+ window/2;
    subImage= double(myImage( ymin:ymax, xmin:xmax, :));
    
    avgNoise= mean(subImage(:));
    stdNoise= std(subImage(:));
%     imagesc(subImage);

end




