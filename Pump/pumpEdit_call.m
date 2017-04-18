function pumpEdit_call( source, data , pump)
%% pumpEdit_call
% Make sure that the value typed is correct for pump speed.
    
    input = str2double(get(source,'string'));
    if isnan(input)
        errorMsg = strcat('Pump speed must be a numeric value in range [500 - 8000].');
        errordlg(errorMsg,'Invalid Input','modal');
        set(source, 'String', ''); % Should read back current value, really
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