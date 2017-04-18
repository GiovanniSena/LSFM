function [ temp ] = tempHW_getT_NTC( myTemp, sensor )
 %% TEMPHW_GETT_NTC
 %  Read the NTC sensor connected to one of the Arduino ports inputs.
 %  myTemp is the serial socket.
 %  sensor is the port number (currently 0 to 2)
    
    send= ['tempNTC' num2str(sensor) '?'];
    fprintf(myTemp, send);
    
    %fprintf(myTemp, 'tempNTC0?');
    
    reply = fscanf(myTemp);
    
    expectedAns= ['TemperatureNTC' num2str(sensor) ' (C)'];
    if (strfind(reply, expectedAns) == 1)
        [token, remain] = strtok(reply , ':'); % Remove text and leave just temperature in Celsius
        temp = str2num(remain(2:end));
    else
        temp= -300;
    end
    
    %disp(num2str(temp));
end

