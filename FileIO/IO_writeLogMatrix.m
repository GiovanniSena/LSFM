function IO_writeLogMatrix( logDir, stackName, best_A )
%%  WRITELOGMATRIX Writes the transformation matrix to a text file
%   This function is used to write the transformation matrix and write it
%   in the correct log file in text format.
    
    fileSplit= strsplit(stackName, '.');
    fileNameLog = [char(fileSplit(1)) '.txt']; %NAME OF THE LOG FILE
    fid = fopen([logDir fileNameLog], 'a+');
    fprintf(fid, 'best_A=\n');
    fclose(fid);
    dlmwrite([logDir fileNameLog], best_A, '-append')
end

