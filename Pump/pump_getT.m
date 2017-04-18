function [ temp ] = pump_getT( myPump )
%% PUMP_GETT
%  Get temperature reading.

    fprintf(myPump, 'temp');
    %pause(1);
    %nBytes = myPump.BytesAvailable;
    %reply = fscanf(myPump, '%s', nBytes); %24 bytes per reading.
    reply = fscanf(myPump);
    %disp(['getT ' reply]);
    
    if (strfind(reply, 'Temperature (C)') == 1)
        [token, remain] = strtok(reply , ':'); % Remove text and leave just temperature in Celsius
        %if(token== 'Temperature (C)')
        temp = str2num(remain(2:end));
    else
        temp= -300;
    end
    %disp(num2str(temp));
end

