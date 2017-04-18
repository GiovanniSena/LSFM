function [myTemp] = tempHW_initialize( sPort )
%% TEMPHW_INITIALIZE Open serial connection with Arduino, returns serial object
%   
    %sPort= 'COM10';
    myTemp = serial(sPort,'BaudRate',9600, 'Terminator', 'LF');%/CR

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

