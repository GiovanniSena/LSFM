function [ best_A ] = retrieveBestA( inFile )
 %% RETRIEVEBESTA Read the log "inFile" and extracts the matrix used to move the motors
 %  The log file is opened and searched to find best_A. If found, it is
 %  returned. If not, the identity matrix is returned instead.
 
    %inFile = 'D:\LSM_Data\OldFiles\150923_TestAutotrackWithPlant\Run0001_150923_1550.txt';
    
    content= fileread(inFile);
    
    pos = strfind(content, 'best_A=');
    
    % I might need to check if multiple instances of the matrix are present
    % in the file
    best_A= eye(4);
    if (~isempty(pos))
        bestString=  content(pos(1)+7:end);
        sizeA= [4 Inf];
        
        best_A = sscanf(bestString, '%f, %f, %f, %f', sizeA);
        best_A = best_A';
    end
    %disp(num2str(best_A, '%2.7f'));
    

end

