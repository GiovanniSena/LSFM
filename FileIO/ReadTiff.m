function ReadTiff( inFile )
%%  Read properties from a tiff file
%   Utility function to read the properties of a TIFF file.
%   The function also sets the image's "Artis" tag to a user specified
%   value.
    
    artistTag= 'P. Baesso';
    %inFile = 'D:\Images\Test\testWriteTiff_2.tif';
    t = Tiff(inFile,'r+');
    try
        artist_value = t.getTag('Artist');
    catch err
        if(strcmp(err.identifier,'MATLAB:imagesci:Tiff:tagRetrievalFailed'))
            t.setTag('Artist', artistTag);
            artist_value = t.getTag('Artist');
        end
    end
    disp(artist_value);
    imagesc(imread(inFile));
    t.close();
end

