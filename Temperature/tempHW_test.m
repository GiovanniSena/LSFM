function  tempHW_test(  )
%%  TEMPHW_TEST Test the Arduino temperature controller
%   This is an utility function to verify the functionality of the
%   hardware. It will establish a connection over serial port, read the
%   value of the temperature probes, set the Peltier cell power to 99, then
%   0. Finally, close the serial link.


%   s = serial('COM10','BaudRate',9600, 'Terminator', 'LF/CR');

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
    
    tempHW_close(myTemp);
end

