function [ peltPower ] = tempHW_setPeltier( myTemp, power)
%%  TEMPHW_SETPELTIER Set the Peltier power value.
%   Sets the power level of the Peltier cell. Note that if the cell is off
%   this function will not switch it on. However, the power value will be
%   stored in the Arduino and set the next time the cell is switched on.
%   "power" is a single precision number between 0 and 99.

%   Sanity check on values
    if (power<0)
        power=0;
    end
    if (power>99)
        power=99;
    end
    fprintf(myTemp, ['pwr ' num2str(power)]);
    %fprintf('Pelt power at %2.0f\n', power);
end

