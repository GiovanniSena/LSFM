function SaveImageToFile( myImage, outFile )
 %SAVEIMAGETOFILE Save myImage to the outfile
 %   If outfile already exists, the image is appended to it. Otherwise a
 %   new file is created.
 %   This is a basic function. For more see http://uk.mathworks.com/help/matlab/import_export/exporting-to-images.html#br_c_iz-1
    if exist(outFile, 'file')
        % File exists.
        imwrite(myImage, outFile, 'Compression', 'none', 'WriteMode','append');
        warningMessage = sprintf('File %s exist: new image appended\n%s', outFile);
        
    else
        % File does not exist.
        warningMessage = sprintf('File %s does not exist: it will be created\n%s', outFile);
        imwrite(myImage, outFile, 'Compression', 'none');
    end
    disp(warningMessage);

end

