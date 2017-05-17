function pumpEdit_call( source, data , pump)
%%  PUMPEDIT_CALL Sets the pump speed based on the GUI parameters.
%   This function interpretes the data typed in the GUI and sets the pump
%   speeds accordingly. All the sanity checks to ensure that correct values are
%   sent to the pump should be performed here.
    
    input = str2double(get(source,'string'));
    if isnan(input)
        errorMsg = strcat('Pump speed must be a numeric value in range [500 - 8000].');
        errordlg(errorMsg,'Invalid Input','modal');
        set(source, 'String', '');
        return
    else
        if (input > 8000)
            input = 8000;
            set(source, 'String', input);
        elseif (input < 500)
            input = 500;
            set(source, 'String', input);
        end
        %radioButton =  getappdata(gcf, 'pumpRadio');
        %selectPump = str2num(get(get(radioButton,'SelectedObject'), 'tag'));
        myPump = getappdata(gcf, 'myPump');
        pump_set( myPump, pump, input );
    end
end