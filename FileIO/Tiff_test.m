function Tiff_test( outFile )
    %   Read properties from a tiff file
    %   http://uk.mathworks.com/help/matlab/import_export/exporting-to-images.html#br_c_iz-6
        
        width= 1040;
        height= 1392;
        imgdata = zeros(width, height, 'uint16');
        
        for i= 1 : height 
            for j= 1: width
                tmp= j*i;
                imgdata((i-1)*width + j)= tmp/22;
            end
        end
        imgSize = size(imgdata);
        disp(num2str(imgSize));

        
    %   Open a new tif file.
        outFile= 'D:\Images\Test\testWriteTiff.tif';
        t = Tiff(outFile,'w');

    
    %Opening a new file will make the created IFD the current IFD so all
    %fields will be written there.
        tagstruct.ImageLength = size(imgdata,1);
        tagstruct.ImageWidth = size(imgdata,2);
        tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
        tagstruct.BitsPerSample = 16; %OK
        tagstruct.SamplesPerPixel = 1; %OK
        tagstruct.RowsPerStrip = 16;
        tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
        tagstruct.Software = 'MATLAB';
        tagstruct.SubIFD = 2;  % required to create subdirectories
        t.setTag(tagstruct);
        
        t.write(imgdata);
        t.writeDirectory();
        

        t.close();

end

