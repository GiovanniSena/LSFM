function [ temp ] = tempHW_getT_NTC( myTemp, sensor )
%%  TEMPHW_GETT_NTC Query one of the temperature probes.
%   Read the NTC sensor connected to one of the Arduino port inputs.
%   myTemp is the serial socket.
%   sensor is the port number (currently 0 to 2).
%   A reading of -300 indicates an error in the communication (or the
%   sudden failure of fundamental physics' laws).
    
%   Query the temperature sensor
    send= ['tempNTC' num2str(sensor) '?'];
    fprintf(myTemp, send);
%   Parse the reply from Arduino    
    reply = fscanf(myTemp);
    expectedAns= ['TemperatureNTC' num2str(sensor) ' (C)'];
    if (strfind(reply, expectedAns) == 1)
        [token, remain] = strtok(reply , ':'); % Remove text and leave just temperature in Celsius
        temp = str2num(remain(2:end));
    else
        temp= -300;
    end
end

