function  pump_test(  )
%PUMP_TEST Summary of this function goes here
%   Detailed explanation goes here
%s = serial('COM10','BaudRate',9600, 'Terminator', 'LF/CR');
    
    myPump= pump_initialize('COM15');
    pause(1);
    
    pump_start(myPump, 0);
    
    
    for i= 1:7
        pump_set(myPump, 1, 1000+1000*i);
        pause(1);
    end
    pump_stop(myPump, 0);
    pump_close(myPump);
%instrfind
%instrfindall
end

