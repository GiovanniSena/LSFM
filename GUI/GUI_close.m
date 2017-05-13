function  GUI_close( source, data, mainFig )
%%  GUI_CLOSE Close main application
%   Check that nothing is left pending before closing the GUI.
%   This function closes all the communication ports before closing the GUI
%   panels. It is important that all the hardware ports are closed
%   correctly, so that they do not get locked.
    
    disp('NOW CLOSING...');

%   Terminate timers (if any left)
    if (isappdata(mainFig, 'webTimer'))
        webTimer= getappdata(mainFig, 'webTimer');
        delete(webTimer);
        clear 'webTimer';
    end
    if (isappdata(gcf, 'mainTimer'))
        mainTimer= getappdata(mainFig, 'mainTimer');
        delete(mainTimer);
        clear 'mainTimer';
    end
    if (isappdata(mainFig, 'temperatureTimer'))
        temperatureTimer= getappdata(mainFig, 'temperatureTimer');
        delete(temperatureTimer);
        clear 'temperatureTimer';
        rmappdata(mainFig, 'temperatureTimer'); 
    end
    if (isappdata(mainFig, 'collisionTimer'))
        collisionTimer= getappdata(mainFig, 'collisionTimer');
        stop(collisionTimer);
        delete(collisionTimer);
        clear 'collisionTimer';
        rmappdata(mainFig, 'collisionTimer');
    end
    if (isappdata(mainFig, 'inScanTimer'))
        inScanTimer= getappdata(mainFig, 'inScanTimer');
        stop(inScanTimer);
        delete(inScanTimer);
        clear 'inScanTimer';
        rmappdata(mainFig, 'inScanTimer');
    end
    if (isappdata(mainFig, 'temperatureGUITimer'))
        temperatureGUITimer= getappdata(mainFig, 'temperatureGUITimer');
        stop(temperatureGUITimer);
        delete(temperatureGUITimer);
        clear 'temperatureGUITimer';
        rmappdata(mainFig, 'temperatureGUITimer');
    end
    if (isappdata(mainFig, 'peltierThermostat'))
        peltierThermostat= getappdata(mainFig, 'peltierThermostat');
        stop(peltierThermostat);
        delete(peltierThermostat);
        clear 'peltierThermostat';
        rmappdata(mainFig, 'peltierThermostat');
    end
    delete(timerfind);
        
%   Close camera: important to prevent the port from getting locked
    if (isappdata(mainFig, 'vidobj') && (isappdata(mainFig, 'videosrc')));
        video_obj = getappdata(mainFig, 'vidobj');
        video_src = getappdata(mainFig, 'videosrc');
        camera_close(video_obj, video_src); 
    end
%   Close webcam communication
    if (isappdata(mainFig, 'webcam'))
      webcam = getappdata(mainFig, 'webcam');
      web_close(webcam); 
    end
%   Close serial connection to arduino Pump
    if (isappdata(mainFig, 'myPump'))
       myPump = getappdata(mainFig, 'myPump');
       pump_close(myPump); 
    end
%   Close serial connection to arduino Temperature hardware
    if (isappdata(mainFig, 'myTemp'))
       myTemp = getappdata(mainFig, 'myTemp');
       tempHW_close(myTemp); 
    end
%   Close filter wheel
    if (isappdata(mainFig, 'FWSerial'))
        FWSerial = getappdata(mainFig, 'FWSerial');
        FW_close(FWSerial);
    end
        
%   Close windows and subfigure (if any exist)
    if (isappdata(mainFig, 'cfgGUIhandle'))
        cfgGUIhandle = getappdata(mainFig, 'cfgGUIhandle');
        delete(cfgGUIhandle);
    end
end

