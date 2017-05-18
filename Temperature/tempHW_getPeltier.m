function [ peltPower ] = tempHW_getPeltier( myTemp )
%%  TEMPHW_GETPELTIER Read the power setting of the peltier cell.
%   Read the status of the peltier cell. Return the power setting (0-99%).
%   If an error occurs, return -1.
%   myTemp is the handle of the serial communication with the temperature
%   Arduino.

%   Query hardware for power setting    
    fprintf(myTemp, 'pwr?');
    reply = fscanf(myTemp);
%   Parse the returned string and display value    
    if (strfind(reply, 'Power %: ') == 1)
        [token, remain] = strtok(reply , ':'); % Remove text and leave just power setting in percentage
        peltPower = str2num(remain(2:end));
        fprintf('PELTIER POWER AT %d %%\n', peltPower);
    else
        peltPower= -1;
    end
end

