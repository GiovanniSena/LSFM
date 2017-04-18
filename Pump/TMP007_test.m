function  pump_test(  )
%PUMP_TEST Summary of this function goes here
%   Detailed explanation goes here
%s = serial('COM10','BaudRate',9600, 'Terminator', 'LF/CR');
    
    myPump= pump_initialize('COM10');
        pause(1);
    
    fileID = fopen('H:\Documents\LSM_Docs\LSM_Calibrations\Pump Calibration\TMP007_data2.txt','a');
        
        
    
for i= 1:10
    
    T= pump_getT(myPump);
    pause(5);
    fprintf(fileID,'%2.3f\n',T);
    disp(T);
end
    pump_stop(myPump, 0);
    pump_close(myPump);

    fclose(fileID);

    %instrfind
    %instrfindall
end

