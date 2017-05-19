function [A ] = readLogFile( fileName )
%%  READLOGFILE Parse a log file from the LSFM program

    fileID = fopen(fileName,'r');
    if (fileID ~= -1)
        fprintf('Log file open ... ');
        formatSpec = '%s X= %f; Y=%f; Z=%f; C=%f; F=%f; YSpacing= %f mm \n'; %imageName, XPos, YPos, ZPos, CPos, Fpos, Spacing 
        A= textscan(fileID, formatSpec);
        fclose(fileID);
        fprintf('Log file closed\n');
    else
        A= [];
        fprintf('Error reading log file\n');
    end
end

