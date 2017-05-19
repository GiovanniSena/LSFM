function [ fileNameList ] = listFilesInFolder( myFolder )
 %% LISTFILESINFOLDER Returns a list containing the names of the image files in the folder
 %  This function searches for .tif files in the folder.
 
    fileNameList = dir([myFolder '*.tif']);
    
end

