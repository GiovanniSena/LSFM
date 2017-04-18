function [ state ] = GUI_shutterToggle( motor, state )
 %% GUI_SHUTTERTOGGLE Toggle laser shutter and update GUI indicators
 %   
    confData= getappdata(gcf, 'confPar');
    DEBUG= confData.application.debug;
    
    
    disp(state);
    try HW_shutterToggle(motor, state); % Should check if this is successful...
    catch
        errorMsg = (' error in switching shutter state.');
        error(errorMsg);
        return
    end
    
    ShutterInd = getappdata(gcf, 'ShutterInd');
    BGColor = getappdata(gcf, 'BGColor');
    
    if(state)
        set(ShutterInd, 'string', '<html>SHUTTER<br>OPEN');
        set(ShutterInd, 'backgroundcolor', 'green');
    else
        set(ShutterInd, 'string', '<html>SHUTTER<br>CLOSED');
        set(ShutterInd, 'backgroundcolor', 'default');
    end
end

