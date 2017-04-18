function pumpEdit_call_calibrated( source, data , pump)
%% pumpEdit_call
% Make sure that the value typed is correct for pump speed.
    minValue = 0.15;
    maxValue = 0.9;
    
    input = str2double(get(source,'string'));
    if isnan(input)
        errorMsg = strcat('Pump speed must be a numeric value in range [', num2str(minValue), ' - ', num2str(maxValue), '] ml/min.');
        errordlg(errorMsg,'Invalid Input','modal');
        set(source, 'String', ''); % Should read back current value, really
        return
    else
        if (input > maxValue)
            input = maxValue;
            set(source, 'String', input);
        elseif (input < minValue)
            input = minValue;
            set(source, 'String', input);
        end
        
        configData= getappdata(gcf, 'confPar');
        offset = str2double(configData.pump.offset);
        conversion = str2double(configData.pump.conversion);
        pumpSpeed = round((input - offset)/conversion);
        
        myPump = getappdata(gcf, 'myPump');
        pump_set( myPump, pump, pumpSpeed );
    end

end