function [ FWSerial ] = FW_initialize(sPort )
%%  FW_INITIALIZE Open communication with filter wheel
%   Opens communication with the serial port dedicated to the filter wheel
%   and defines the communication parameters.
%   Note that the Thorlabs filter wheel has a slightly odd protocol of
%   communication that requires specific line terminators.
%   Also, the wheel will echo any command sent to it.
%   This function takes these details into account.

    %sPort= 'COM16';
    FWSerial = serial( sPort,'BaudRate',115200);
    FWSerial.Terminator= {'CR', 'CR'}; % READ TERMINATOR, WRITE TERMINATOR
    FWSerial.databits= 8;
    FWSerial.Timeout= 3;
    try
        fopen(FWSerial);
        disp('FILTER WHEEL OPEN');
        % Sometimes the communication takes some time to establish. Insert
        % a delay.
        pause(1);
        
    %   Identify the wheel
        command = '*idn?';
        fprintf(FWSerial, command);
        readback= fgets(FWSerial); % ECHO
        readback= fgets(FWSerial); % ACTUAL DATA
    %   Initialize the wheel to position 1 
        FW_setPos(FWSerial, 1);
    catch
       delete(instrfind('Port', sPort));
       disp('Error opening serial communication with filter wheel');
    end
end

