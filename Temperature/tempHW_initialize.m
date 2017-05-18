function [myTemp] = tempHW_initialize( sPort )
%%  TEMPHW_INITIALIZE Open serial connection with Arduino, returns serial object
%   Establish a serial connection with the temperature Arduino. The
%   function returns the handle to the serial object created.
%   "Port" is the COM port to which the Arduino is connected.
    
    %sPort= 'COM10'; %for debug purposes
%   Initialize serial parameters
    myTemp = serial(sPort,'BaudRate',9600, 'Terminator', 'LF');%/CR
%   Attempt to open the port
    try
        fopen(myTemp);
        disp('TEMP_HW OPEN');
    catch
       delete(instrfind('Port', sPort));
       disp('Error opening serial communication');
    end
    pause(3); %Needed after opening to ensure the communication is active.
    fprintf(myTemp, '*idn?');
    readback= fscanf(myTemp);
%     if readback== 'PUMP and TEMPERATURE PROBE'
%         myMsg= 'PUMP OPEN';
%     else
%         myMsg= 'Error opening pump communication: check COM settings';
%     end
%     disp(myMsg);
end

