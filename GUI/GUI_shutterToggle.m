function [ state ] = GUI_shutterToggle( motor, state )
%%  GUI_SHUTTERTOGGLE Toggle laser shutter and update GUI indicators
%   Instructs the GUI to toggle the shutter status, updating the indicators
%   and sending the command to the hardware.

    confData= getappdata(gcf, 'confPar');
    
    disp(state);
    try HW_shutterToggle(motor, state);
    catch
        errorMsg = (' error in switching shutter state.');
        error(errorMsg);
        return
    end
    
    ShutterInd = getappdata(gcf, 'ShutterInd');
    
    if(state)
        set(ShutterInd, 'string', '<html>SHUTTER<br>OPEN');
        set(ShutterInd, 'backgroundcolor', 'green');
    else
        set(ShutterInd, 'string', '<html>SHUTTER<br>CLOSED');
        set(ShutterInd, 'backgroundcolor', 'default');
    end
end

