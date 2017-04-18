function [M ] = readBeadFile( fileName )
%% READBEADFILE Summary of this function goes here
% 'D:\LSM_Data\020615_manualScan\020615_manualScan_001.dat'
% 
%     fileID = fopen(fileName,'r');
%     if (fileID ~= -1)
%         disp('BEAD FILE OPEN');
%         formatSpec = '%s X= %f; Y=%f; Z=%f; C=%f; F=%f; YSpacing= %f mm \n'; %imageName, XPos, YPos, ZPos, CPos, Fpos, Spacing 
%         %sizeA = [7 Inf];
%         %A = fscanf(fileID, formatSpec, sizeA);
%         %A = fscanf(fileID, formatSpec);
%         A= textscan(fileID, formatSpec);
%         %A= A';
%         fclose(fileID);
%     else
%         A= [];
%         disp('ERROR READING LOG FILE');
%     end
    
    M = dlmread(fileName);
    %disp(M(3,2)); % M(*,2) element * of Y
end

