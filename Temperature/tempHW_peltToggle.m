function tempHW_peltToggle( myTemp, status )
%% TEMPHW_PELTTOGGLE
%  Toggle the peltier cell On/Off.
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

