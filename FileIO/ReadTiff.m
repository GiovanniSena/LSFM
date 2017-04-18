function ReadTiff( inFile )
    %   Read properties from a tiff file
    %   
    inFile = 'D:\Images\Test\testWriteTiff_2.tif';
    t = Tiff(inFile,'r+');
    try
        artist_value = t.getTag('Artist');
    catch err
        if(strcmp(err.identifier,'MATLAB:imagesci:Tiff:tagRetrievalFailed'))
            t.setTag('Artist','P. Baesso');
            artist_value = t.getTag('Artist');
        end
    end
    disp(artist_value);
    imagesc(imread(inFile));
    t.close();

end

