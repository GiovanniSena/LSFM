function [ posArray ] = GUI_readFileMaxPosition( mainFig )
 %% GUI_READFILEMAXPOSITION Read the last line of the rootsearch.txt file and returns the positions
 %  Rootsearch.txt contains the result of the scan to find the root
 %  position. The last line in the file corresponds to the most likely
 %  location for the root tip.

    confData= getappdata(mainFig, 'confPar');
    logdir= confData.application.logdir;
    
    fileID = fopen([logdir 'rootsearch.txt'],'r'); %# Open the file as a binary
    lastLine = '';                   %# Initialize to empty
    offset = 1;                      %# Offset from the end of file
    fseek(fileID,-offset,'eof');        %# Seek to the file end, minus the offset
    newChar = fread(fileID,1,'*char');  %# Read one character
    while (~strcmp(newChar,char(10))) || (offset == 1)
        lastLine = [newChar lastLine];   %#ok<AGROW> %# Add the character to a string
        offset = offset+1;
        fseek(fileID,-offset,'eof');        %# Seek to the file end, minus the offset
        newChar = fread(fileID,1,'*char');  %# Read one character
    end
    fclose(fileID);  %# Close the file
    
  % RETURN AN ARRAY WITH THE POSITIONS
    posArray = sscanf(lastLine, 'ROOT SCAN AVG= %f AT X= %f, Y= %f, Z= %f, C= %f, F= %f\n');
    posArray(1) = []; %remove first element since it is the average intensity value
    
end

