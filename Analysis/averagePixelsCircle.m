function [ meanInsideCircle, sdInsideCircle, I_col, I_row ] = averagePixelsCircle( myImage, xCoord, yCoord, boxSize, radius )
 %% AVERAGEPIXELSCIRCLE Calculate average intensity in the pixles contained in a circle
 %  The function looks for the pixel with highest intensity (Pmax=(I_row, I_col)) in a box
 %  located at (xCoord, yCoord). Then defines a circular mask around Pmax
 %  and calculates average and st. deviation of the pixels within the
 %  radius.
 
    %disp(['Calculating average in pixels)']);
    if (boxSize < radius)
        boxSize= radius;
    end
    [myImageSizeX, myImageSizeY] = size(myImage);
    xMin=round(xCoord-boxSize/2);
    xMax=round(xCoord+boxSize/2);
    yMin=round(yCoord-boxSize/2);
    yMax=round(yCoord+boxSize/2);
    
    if xMin<1
        xMin=1;
    end
    if xMax > myImageSizeX
        xMax = myImageSizeX;
    end
 
    if yMin<1
        yMin=1;
    end
    if yMax > myImageSizeY
        yMax = myImageSizeY;
    end
    
    %subImage=myImage(xCoord-boxSize/2:xCoord+boxSize/2, yCoord-boxSize/2:yCoord+boxSize/2); % DEFINE SEARCH BOX
    subImage=myImage(xMin:xMax, yMin:yMax); % DEFINE SEARCH BOX
    [maxValue, maxIndex]= max(subImage(:)); % FIND MAXIMUM INTENSITY IN SEARCH BOX
    %disp(num2str(maxValue));
    [I_row, I_col] = ind2sub(size(subImage),maxIndex); % COORDINATES OF PIXEL WITH HIGHEST INTENSITY
    
    [subImageSizeY, subImageSizeX] = size(subImage);
    [columnsInImage, rowsInImage] = meshgrid(1:subImageSizeX, 1:subImageSizeY);
 % Next create the circle mask as a 2D "logical" array.
    circleMask = (rowsInImage - I_row).^2 + (columnsInImage - I_col).^2 <= radius.^2;

 % Find average pixel intensity in the circle   
    %meanInsideCircle =  mean2(subImage(:,:));
    %sdInsideCircle = std2(single(subImage(:,:)));
    meanInsideCircle = mean(subImage(circleMask));
    sdInsideCircle = std(single(subImage(circleMask)));
    
 % Display subimage
     %image(subImage);
     %colormap(gray);
     %z=image(myImage(xCoord-boxSize:xCoord+boxSize, yCoord-boxSize:yCoord+boxSize));
%     
 % Print values
    %disp(['Pmax= (' num2str(I_col) ',' num2str(I_row) '); Radius= ' num2str(radius) '; Mean= ' num2str(meanInsideCircle) '; StDev= ' num2str(sdInsideCircle)]);
end

