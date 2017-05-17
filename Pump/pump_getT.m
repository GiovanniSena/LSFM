function [ temp ] = pump_getT( myPump )
%%  PUMP_GETT Query the Arduino hardware to retrieve temperature.
%   Get temperature reading from the corresponding serial resource. This
%   function is now deprecated since the temperature probes are no longer
%   connected to the same Arduino controlling the pump.

    fprintf(myPump, 'temp');
    reply = fscanf(myPump);
    if (strfind(reply, 'Temperature (C)') == 1)
        [token, remain] = strtok(reply , ':'); % Remove text and leave just temperature in Celsius
        temp = str2num(remain(2:end));
    else
        temp= -300;
    end
end

