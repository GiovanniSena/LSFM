function SaveImageToTIFF( myImage, outFile )
 %SAVEIMAGETOFILE Save myImage to the outfile
 %   If outfile already exists, the image is appended to it. Otherwise a
 %   new file is created.
 %   This is a basic function. For more see http://uk.mathworks.com/help/matlab/import_export/exporting-to-images.html#br_c_iz-1
    if exist(outFile, 'file')
     % File exists.
        warningMessage = sprintf('File %s exists: image appended\n%s', outFile);
        myTiff = Tiff(outFile,'a');
     
    else
     % File does not exist.
        warningMessage = sprintf('File %s does not exist: it will be created\n%s', outFile);
        myTiff = Tiff(outFile,'w');
    end   
     % Create tag structure and populate it
        tagstruct.Artist = 'P. Baesso'; % OK
        formatOut = 'mm/dd/yy';
        tagstruct.DateTime = datestr(now, formatOut);
        tagstruct.ImageLength = size(myImage,1); % OK
        tagstruct.ImageWidth = size(myImage,2); % OK
        tagstruct.Photometric = Tiff.Photometric.MinIsBlack; % OK
        tagstruct.BitsPerSample = 16; % OK
        tagstruct.SamplesPerPixel = 1; % OK
        tagstruct.RowsPerStrip = 1; % OK
        tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky; % OK
        tagstruct.Software = 'MATLAB';
        tagstruct.SampleFormat = 1; % UINT
        tagstruct.SMinSampleValue = 0;
        tagstruct.SMaxSampleValue = 65535;
        tagstruct.Compression = 1; % NO COMPRESSION 
        %tagstruct.Orientation = 1; %1= normal, 6= rotate CW 90, 8= rotate CCW 90.
        
        myTiff.setTag(tagstruct);
        %myTiff.writeDirectory();
        
     % Write image data
        myTiff.write(myImage);
        size(myImage)
        myTiff.writeDirectory();
        
        myTiff.close();
        %imagesc(imread(outFile));
    
    disp(warningMessage);

end






