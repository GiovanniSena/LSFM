function pump_start( myPump, pump )
%%  PUMP_START Activates the corresponding pump.
%   Start one of the pumps connected to the Arduino hardware.

    switch pump
        case 0
            command = 'start';
        case 1
            command = 'start1';
        case 2
            command = 'start2';
    end
        fprintf(myPump, command);
end

