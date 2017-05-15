function [ currentPos ] = FW_getPos( FWSerial )
%%  FW_GETPOS Returns the current position of the filter wheel
%   Current position is an integer number between 1 and 6.
 
    disp('GET FW POSITION');
    command = 'pos?';
    fprintf(FWSerial, command);
    pause(1);
    readback = fgets(FWSerial); % ECHO
    currentPos= fgets(FWSerial); %ACTUAL DATA
end

