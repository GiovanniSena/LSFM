function [A ] = readLogFile( fileName )
%% READLOGFILE Summary of this function goes here
%   imageName, XPos, YPos, ZPos, CPos, Fpos, Spacing 
%   'D:\LSM_Data\260515_scanLong\260515_scanLong.txt'
%   Resulting data can be extracted as A{i} with i= 1 to 7

    fileID = fopen(fileName,'r');
    if (fileID ~= -1)
        %disp('LOG FILE OPEN');
        fprintf('Log file open ... ');
        formatSpec = '%s X= %f; Y=%f; Z=%f; C=%f; F=%f; YSpacing= %f mm \n'; %imageName, XPos, YPos, ZPos, CPos, Fpos, Spacing 
        %sizeA = [7 Inf];
        %A = fscanf(fileID, formatSpec, sizeA);
        %A = fscanf(fileID, formatSpec);
        A= textscan(fileID, formatSpec);
        %A= A';
        fclose(fileID);
        fprintf('Log file closed\n');
    else
        A= [];
        %disp('ERROR READING LOG FILE');
        fprintf('Error reading log file\n');
    end
    
end

