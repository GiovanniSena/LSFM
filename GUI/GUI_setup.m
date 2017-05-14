function GUI_setup( sourceBtn )
 %% GUI_SETUP POsition the cuvette and camera to whereabout of root and TPS
 %  This function positions the cuvette so that its corner is near the TPS
 %  and moves the camera to focus that area. It can be used to set up the
 %  experiment. The user will then need to look around the area for final
 %  adjustmens.
 
%   RETRIEVE THE NAME OF THE PARENT FIGURE FOR THE BUTTON
    mainFig= GUI_getParentFigure(sourceBtn);
    
%   RETRIEVE MOTOR HANDLES  
    motorHandles = getappdata(mainFig, 'actxHnd');
    confData= getappdata(mainFig, 'confPar');
    safedist = str2double(confData.motor.safedist_fy);
    
%   CHANGE STATUS OF AF INDICATOR (green, on), DISABLE BUTTON
    oldString= get(sourceBtn, 'string');
    set(sourceBtn, 'string', 'WAIT');
    set(sourceBtn, 'enable', 'off');
    
    
%   STORE OLD POSITIONS
    nMotors= numel(motorHandles)-1;
    oldPos(1:nMotors)=0;
    for i=1:nMotors
        oldPos(i)= HW_getPos(motorHandles(i));
    end
  
%   APPROXIMATE LOCATION OF TPS
    sx=18.8;
    sy=10.5;
    c=20.10;
    
%   CHECK FOR POSSIBLE COLLISION Sy-F
    attemptDist= safedist - (sy +  oldPos(5));
    minimumAcceptedDist= 0.5;
    finalDistance= attemptDist-minimumAcceptedDist;
    if finalDistance >= 0
        fprintf('Positioning cuvette (X, Y) and camera (X).\n');
    else
        fprintf('Current position will cause crash. Retracting camera Y.\n');
        HW_moveRelative(motorHandles(5),  finalDistance-0.1);
    end
    
%   POSITION MOTORS
    HW_moveAbsolute(motorHandles(1), sx);
    HW_moveAbsolute(motorHandles(2), sy);
    HW_moveAbsolute(motorHandles(4), c);
    
%   CHANGE STATUS OF AF INDICATOR (green, on), DISABLE BUTTON
    set(sourceBtn, 'string', oldString);
    set(sourceBtn, 'enable', 'on');
  
end

