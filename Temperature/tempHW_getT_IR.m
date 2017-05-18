function [ temp ] = tempHW_getT_IR( myTemp )
%%  TEMPHW_GETT_IR Query the temperature probes.
%   Read the IR temperature sensor connected to the temperature Arduino 
%   and return temperature in Celsius. If an error occurs the function
%   returns -300 C.

%   Query Arduino for infra-red sensor value
    fprintf(myTemp, 'tempIR?');
    reply = fscanf(myTemp);
%   Parse the answer and display it
    if (strfind(reply, 'TemperatureIR (C)') == 1)
        [token, remain] = strtok(reply , ':'); % Remove text and leave just temperature in Celsius
        temp = str2num(remain(2:end));
    else
        temp= -300;
    end
end

