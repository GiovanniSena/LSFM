function  tempHW_test(  )
%TEMPHW_TEST Summary of this function goes here
%   Detailed explanation goes here
%s = serial('COM10','BaudRate',9600, 'Terminator', 'LF/CR');

    fprintf('Running script, please wait.\n');
    myTemp= tempHW_initialize('COM13'); % CHANGE THIS PARAMETER ACCORDING TO WHERE THE USB CABLE IS CONNECTED
    pause(1);

    tempIR= tempHW_getT_IR(myTemp);
    tempNTC(1)= tempHW_getT_NTC(myTemp, 0);
    tempNTC(2)= tempHW_getT_NTC(myTemp, 1);
    tempNTC(3)= tempHW_getT_NTC(myTemp, 2);
    fprintf( 'Temperatures [C]. IR= %2.1f, Temp. A= %2.1f, Temp. B= %2.1f, Temp. C= %2.1f\n', tempIR, tempNTC(1), tempNTC(2), tempNTC(3));
    
    myPower= tempHW_getPeltier(myTemp);
    fprintf('Power= %d\n', myPower);
    pause(2);
    
    myPower= 99;
    tempHW_setPeltier(myTemp, myPower);
    myPower= tempHW_getPeltier(myTemp);
    fprintf('Power= %d\n', myPower);
    
    pause(2);
    myPower= 0;
    tempHW_setPeltier(myTemp, myPower);
    myPower= tempHW_getPeltier(myTemp);
    fprintf('Power= %d\n', myPower);
    
    %tempTs= timeseries('Temperature');
    %tempTs.UserData= datetime('now');
    
    %for i=1:10
%         c= now;
%         tempIR= tempIR+1;
%         tempTs.addsample('Time', c , 'Data', tempIR);
%         plot(tempTs);
%         pause(1);
%         disp(tempIR);
%     end
%     plot(tempTs)
    
    tempHW_close(myTemp);
%instrfind
%instrfindall
end

