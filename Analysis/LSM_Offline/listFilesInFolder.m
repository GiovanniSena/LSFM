function [ fileNameList ] = listFilesInFolder( myFolder )
 %% LISTFILESINFOLDER Returns a list containing the names of the image files in the folder
 %  This function searches for .tif files in the folder.
 
    %myFolder= 'D:\LSM_Data\OldFiles\150923_TestAutotrackWithPlant';
    fileNameList = dir([myFolder '*.tif']);
    
    %fileNameList(2).name
    %fileNameList(2).date

end

