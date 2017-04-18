function [ output_args ] = fit2dgauss( input_args )
%FIT2DGAUSS Summary of this function goes here
%   Detailed explanation goes here

    dataDir= 'D:\LSM_Data\150702_AlignmentScan\';
    fileName= '150702_alignmentScan2_001.tif';
    myStack=TIFF_read([dataDir fileName]);
    
    beadCoord= [ 484, 556]; %[y, x] if taken from Image j
    searchSize= 40;
    stackN= 40;
    
    myImage= myStack(:, :, stackN);
    %image(myImage);
    
    subImage=myImage((beadCoord(1)-searchSize/2):(beadCoord(1)+searchSize/2), (beadCoord(2)-searchSize/2):(beadCoord(2)+searchSize/2));
    image(subImage);
    %colormap(gray);
    
    %surf(subImage);
   
    
    [x,y]=meshgrid(1:searchSize+1,1:searchSize+1);
    x=x(:);
    y=y(:);
    z=subImage(:);
    
    %cftool(x, y, z);
    [fitresult, ~]=createFit(x, y, z);
    h = rotate3d;
    h.Enable = 'on';
    
    Ypos= fitresult.x0+ beadCoord(2)-searchSize/2-1 %X in imagej
    Xpos= fitresult.y0+ beadCoord(1)-searchSize/2-1 %Y in imagej
    
end

