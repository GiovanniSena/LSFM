function [ temp ] = tempHW_getT_IR( myTemp )
 %% TEMPHW_GETT_IR
 %  Read the IR temperature sensor and return temperature in Celsius

    fprintf(myTemp, 'tempIR?');
    reply = fscanf(myTemp);
    
    if (strfind(reply, 'TemperatureIR (C)') == 1)
        [token, remain] = strtok(reply , ':'); % Remove text and leave just temperature in Celsius
        temp = str2num(remain(2:end));
    else
        temp= -300;
    end
    %disp(num2str(temp));
end

