function  GUI_close( source, data, mainFig )
%% GUI_CLOSE Close application
%  We should check that nothing is left pending before closing the GUI.

    
 %  Check if scan is running. If it is, send user back to stop it
    %isScanning = getappdata(mainFig, 'isScanning');
    %if (isScanning == 1)
        %errorstring = 'Scan in progress: stop it before closing the application.';
        %h = errordlg(errorstring);
    %else
        disp('NOW CLOSING...');
    

        %pause(5);
    % Terminate timers (if any left)
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
        
    % Close camera (IMPORTANT)
        if (isappdata(mainFig, 'vidobj') && (isappdata(mainFig, 'videosrc')));
            video_obj = getappdata(mainFig, 'vidobj');
            video_src = getappdata(mainFig, 'videosrc');
            camera_close(video_obj, video_src); 
        end
     % Close webcam
        if (isappdata(mainFig, 'webcam'))
          webcam = getappdata(mainFig, 'webcam');
          web_close(webcam); 
        end
     % Close serial connection to arduino Pump (IMPORTANT)
        if (isappdata(mainFig, 'myPump'))
           myPump = getappdata(mainFig, 'myPump');
           pump_close(myPump); 
        end
     % Close serial connection to arduino Temperature hardware (IMPORTANT)
        if (isappdata(mainFig, 'myTemp'))
           myTemp = getappdata(mainFig, 'myTemp');
           tempHW_close(myTemp); 
        end
     % Close filter wheel
        if (isappdata(mainFig, 'FWSerial'))
            FWSerial = getappdata(mainFig, 'FWSerial');
            FW_close(FWSerial);
        end
        
     % Close motors with stopCtrl?
   
     % Close labjack (NOT NECESSARY)
     
     
        

     % Close windows and subfigure (if exists)
        if (isappdata(mainFig, 'cfgGUIhandle'))
            cfgGUIhandle = getappdata(mainFig, 'cfgGUIhandle');
            delete(cfgGUIhandle);
        end
            %delete(gcbf);
         
    %end

end

