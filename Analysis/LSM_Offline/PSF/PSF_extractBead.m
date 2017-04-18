function [ subImg ] = PSF_extractBead( inputImg, xBead, yBead, windowSize )
 %% EXTRACTBEAD Summary of this function goes here
 %  Detailed explanation goes here
 
    %windowSize= 100;
    [ySize, xSize]=size(inputImg);
    
    xMin= max(xBead- windowSize/2, 1);
    xMax= min(xBead+ windowSize/2, xSize);
    
    yMin= max(yBead- windowSize/2, 1);
    yMax= min(yBead+ windowSize/2, ySize);
    
    subImg= inputImg(yMin:yMax, xMin:xMax, :);
    


end

