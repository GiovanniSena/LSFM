function GUI_autofocus( sourceBtn )
 %% GUI_AUTOFOCUS Prepare the GUI for autofocus and call the AF routine
 %  Set the correct indicators to show that the AF routine is active.
 %  Return the indicators to previous status once the routine is completed.
       
 %  RETRIEVE USER VALUE FOR AF SPACING
    confData= getappdata(gcf, 'confPar');
    afSpacing= str2double(confData.user.afspacing);
    vidobj= getappdata(gcf, 'vidobj');
    
 %  GET AF INDICATOR HANDLE
    AFInd = getappdata(gcf, 'AFInd');
   
 %  CHANGE STATUS OF AF INDICATOR (green, on), DISABLE BUTTON
    set(AFInd, 'string', '<html>AF<br>ON');
    set(AFInd, 'backgroundcolor', 'green'); 
    set(sourceBtn, 'string', '<HTML><FONT size="-1">WAIT');
    %set(sourceBtn, 'enable', 'off');
    
 %  DO AUTOFOCUS
    motorHandles = getappdata(gcf, 'actxHnd');
    motor= motorHandles(5);
    tr_autofocus(afSpacing, motor, vidobj);
    
 %  CHANGE STATUS OF AF INDICATOR BACK TO OFF
    set(AFInd, 'string', '<html>AF<br>OFF');
    set(AFInd, 'backgroundcolor', 'default'); 
    set(sourceBtn, 'string', '<HTML><FONT size="-1">AUTO<br>FOCUS');
    set(sourceBtn, 'enable', 'on');
end

