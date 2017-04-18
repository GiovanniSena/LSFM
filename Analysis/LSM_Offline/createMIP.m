function [ MIPimage ] = createMIP(inFolder, inFile )
 %% CREATEMIP Creates a Maximum Intensity Projection 2D image from a 3D stack of images
 %  Take the inputStack and creates a MIP file, where each pixel value is
 %  the maximum along the Z direction. The new file name is the same as the
 %  original one but with '_MIP' appended to the end.
 
    %inFile = 'D:\LSM_Data\OldFiles\150923_TestAutotrackWithPlant\Run0001_150923_1550.tif';
    inputStack= TIFF_read([inFolder inFile]);
    
    %MIPy= max(inputStack,[],1);
    %MIPx= max(inputStack,[],2);
    MIPz= max(inputStack,[],3);
    
    %B= MIPx(:,:,1);
    %colormap('gray');
    %image(B);
    
    MIPimage= squeeze(MIPz); % If we want maximum
    %B= uint16(mean(inputStack, 3)); % If we want average
    
    %outFile = strrep(inFile, '.tif', '_MIP.tif');
    %TIFF_write(MIPimage, outFile);

    
end

