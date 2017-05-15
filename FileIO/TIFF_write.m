function TIFF_write( myImage, outFile )
%%  TIFF_WRITE Save myImage to the outfile
%   If outfile already exists, the image is appended to it. Otherwise a
%   new file is created.
 
    if exist(outFile, 'file')
%   File exists.
        warningMessage = sprintf('File %s exists: image appended\n%s', outFile);
        myTiff = Tiff(outFile,'a'); 
    else
%   File does not exist.
        warningMessage = sprintf('File %s does not exist: it will be created\n%s', outFile);
        myTiff = Tiff(outFile,'w');
    end  
    disp(warningMessage);
%   Create tag structure and populate it
    tagstruct.Artist = 'P. Baesso'; % OK
    formatOut = 'mm/dd/yy';
    tagstruct.DateTime = datestr(now, formatOut); % WINDOWS DOES NOT RECOGNIZE IT BUT MATLAB DOES
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
    tagstruct.Compression = 5; % 1=NO COMPRESSION ; 5=LZW (lossless)

    myTiff.setTag(tagstruct);

%   Write image data
    myTiff.write(myImage);
    myTiff.writeDirectory();

    myTiff.close();
end






