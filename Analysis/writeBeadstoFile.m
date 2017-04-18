function writeBeadstoFile( fileName, beadX, beadY, camXPos, yPositionArray, intensityArray )
%WRITEBEADSTOFILE Summary of this function goes here
%   Detailed explanation goes here

    C = strsplit(fileName, '.');
    
    outFile= strcat(C(1), '_X', num2str(beadX), '_Y', num2str(beadY), '.txt');
    a= [1 4];
    disp(outFile);
    maxInt= max(intensityArray);
    fid = fopen(char(outFile), 'wt');
    fprintf(fid, '%s%f \t %s%f \t %s%f\n', 'X ', beadX, 'Y ', beadY, 'CamX ', camXPos);
    for i=1:size(yPositionArray)
        fprintf(fid,'%f \t %f \t %f\n', yPositionArray(i), intensityArray(i), intensityArray(i)/maxInt);  % The format string is applied to each element of a
    end
    fclose(fid);
end

