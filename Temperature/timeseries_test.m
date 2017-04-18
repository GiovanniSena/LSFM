%function  timeseries_test(  )
%TEMPHW_TEST Summary of this function goes here
%   Detailed explanation goes here
%s = serial('COM10','BaudRate',9600, 'Terminator', 'LF/CR');
    
    figure();
    tempIR=0;
    tempNTC= 3;
    
    tempTs= timeseries('Temperature');
    tempTs.UserData= datetime('now');
    
    for i=1:5
        c= now;
        tempIR= rand;
        tempNTC= rand;
        newEl= [tempIR tempNTC];
        tempTs= tempTs.addsample('Time', c , 'Data', newEl);
        pause(1);
        
    end
    plot(tempTs);
    tempTs.Name
    tempTs.Length
    pause(3);
    
%instrfind
%instrfindall
%end

