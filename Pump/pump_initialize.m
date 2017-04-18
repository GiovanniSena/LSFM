function [myPump] = pump_initialize( sPort )
%% PUMP_INITIALIZE Open serial connection with Arduino, returns serial object
%   
    %sPort= 'COM10';
    myPump = serial(sPort,'BaudRate',9600, 'Terminator', 'LF');%/CR

    try
        fopen(myPump);
        disp('PUMP OPEN');
    catch
       delete(instrfind('Port', sPort));
       disp('Error opening serial communication');
    end
    pause(3); %Needed after opening to ensure the communication is active.
    fprintf(myPump, '*idn?');
    readback= fscanf(myPump);
%     if readback== 'PUMP and TEMPERATURE PROBE'
%         myMsg= 'PUMP OPEN';
%     else
%         myMsg= 'Error opening pump communication: check COM settings';
%     end
%     disp(myMsg);
end

