function [ peltPower ] = tempHW_getPeltier( myTemp, power)
 %% TEMPHW_GETPELTIER
 %  Read the status of the peltier cell. Return the power setting (0-99%).
 %  If an error occurs, return -1.

    if (power<0)
        power=0;
    end
    if (power>99)
        power=99;
    end
    
    fprintf(myTemp, ['pwr ' num2str(power)]);
    %fprintf('Pelt power at %2.0f\n', power);
    
    %disp(num2str(temp));
end

