function GUI_sendtofocus( sourceBtn )
 %% GUI_AUTOFOCUS Send the camera in the focus position
 %  
       
 % RETRIEVE USER VALUE FOR FOCUS FY DISTANCE
    confData= getappdata(gcf, 'confPar');
    fdistance= str2double(confData.motor.focusdist_fy);
    
 % CHANGE STATUS OF BUTTON
    set(sourceBtn, 'string', 'WAIT');
    
 % DO AUTOFOCUS
    motorHandles = getappdata(gcf, 'actxHnd');
    CamMotor= motorHandles(5);
    SyMotor= motorHandles(2);
    tr_sendtofocus(fdistance, CamMotor, SyMotor);
    
 % CHANGE STATUS OF BUTTON
    set(sourceBtn, 'string', 'FOCUS');
    
end

