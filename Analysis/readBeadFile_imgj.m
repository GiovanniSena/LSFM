function [Mreturn ] = readBeadFile_imgj( fileName )
%% READBEADFILE Read a file containing the pixel locations of the beads.
% 'D:\LSM_Data\110615_X20_rubbish\res.txt'
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
    
    M = dlmread(fileName, '', 1, 0); % SKIP ROW 0
    [nEntries, ~]= size(M);
    Mreturn= zeros(nEntries, 2);
    Mreturn(:, 1)= M(:, 7);
    Mreturn(:, 2)= M(:, 6);
    Mreturn= round(Mreturn);
   % Mreturn= zeros(
   % Mreturn(1)= M(6, :);
   % Mreturn(2)= M(7, :);
    
    %disp(M(3,2)); % M(*,2) element * of Y
end

