function GUI_sendtofocus( sourceBtn )
%%  GUI_AUTOFOCUS Position the microscope in the focus position
%   This utility function instructs the system to move the Y stages (cuvette and
%   camera) to the approximate location of the focus. Once done it executes
%   an autofocus routine to try to get a clear image of the sample.
       
%   RETRIEVE USER VALUE FOR FOCUS FY DISTANCE
    confData= getappdata(gcf, 'confPar');
    fdistance= str2double(confData.motor.focusdist_fy);
    
%   CHANGE STATUS OF BUTTON
    set(sourceBtn, 'string', 'WAIT');
    
%   DO AUTOFOCUS
    motorHandles = getappdata(gcf, 'actxHnd');
    CamMotor= motorHandles(5);
    SyMotor= motorHandles(2);
    tr_sendtofocus(fdistance, CamMotor, SyMotor);
    
%   CHANGE STATUS OF BUTTON
    set(sourceBtn, 'string', 'FOCUS');
    
end

