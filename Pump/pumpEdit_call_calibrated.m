function pumpEdit_call_calibrated( source, data , pump)
%%  PUMPEDIT_CALL_CALIBRATED Sets the pump speed based on the GUI parameters.
%   This function interpretes the data typed in the GUI and sets the pump
%   speeds accordingly. All the sanity checks to ensure that correct values are
%   sent to the pump should be performed here.
%   This function also applies a calibration to the pump values, so that
%   the user can type a flow (mL/min) rather than an arbitrary value.
%   The calibration parameters used to linearize the flow with the pump
%   speed are retrieved from the config file (pump.offset,
%   pump.conversion). Check the LSFM manual for further details.

    minValue = 0.15;
    maxValue = 0.9;
    
    input = str2double(get(source,'string'));
    if isnan(input)
        errorMsg = strcat('Pump speed must be a numeric value in range [', num2str(minValue), ' - ', num2str(maxValue), '] ml/min.');
        errordlg(errorMsg,'Invalid Input','modal');
        set(source, 'String', '');
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