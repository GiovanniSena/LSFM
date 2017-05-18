function tempHW_peltToggle( myTemp, status )
%%  TEMPHW_PELTTOGGLE Toggles the status of the Peltier cell.
%   Use this function to switch the Peltier cell on or off depending on the
%   value of "status".

    switch status
        case 0
            disp('SET OFF');
            command = 'peltOFF';
        case 1
            disp('SET ON');
            command = 'peltON';
        otherwise
            disp('UNKNOWN');
            command = 'peltOFF';
    end
        fprintf(myTemp, command);
end

