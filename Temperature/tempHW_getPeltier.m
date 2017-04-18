function [ peltPower ] = tempHW_getPeltier( myTemp )
 %% TEMPHW_GETPELTIER
 %  Read the status of the peltier cell. Return the power setting (0-99%).
 %  If an error occurs, return -1.

    
    fprintf(myTemp, 'pwr?');
    reply = fscanf(myTemp);
    
    if (strfind(reply, 'Power %: ') == 1)
        [token, remain] = strtok(reply , ':'); % Remove text and leave just power setting in percentage
        %if(token== 'Temperature (C)')
        peltPower = str2num(remain(2:end));
        fprintf('PELTIER POWER AT %d %%\n', peltPower);
    else
        peltPower= -1;
    end
    %disp(num2str(temp));
end

