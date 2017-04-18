function IO_writeLogMatrix( logDir, stackName, best_A )
 %% WRITELOGMATRIX Summary of this function goes here
 %   Detailed explanation goes here
    
    fileSplit= strsplit(stackName, '.');
    fileNameLog = [char(fileSplit(1)) '.txt']; %NAME OF THE LOG FILE
    fid = fopen([logDir fileNameLog], 'a+');
    fprintf(fid, 'best_A=\n');
    fclose(fid);
    dlmwrite([logDir fileNameLog], best_A, '-append')
    %fid = fopen([logDir fileNameLog], 'a+');
    %fprintf(fid, best_A);
    %fclose(fid);

end

