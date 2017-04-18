function [ output_args ] = GUI_rootSearch( mainFig, sourceBtn )
 %% GUI_ROOTSEARCH Summary of this function goes here
 %   Detailed explanation goes here
    
  % FOCUS = 5
  % Sy = 2
  % Sx= 1
  % Sz= 3
  % C= 4
 
    setappdata(mainFig, 'isSearching', 1);
    setappdata(mainFig, 'maxSearch', 0);
    
    tic()
  % DISABLE BUTTON
    set(sourceBtn, 'string', '<HTML><FONT size="-1">WAIT');
    set(sourceBtn, 'enable', 'off');
    
  % ENABLE ABORT BUTTON
    abort_src_btn= getappdata(gcf, 'abort_src_btn');
    set(abort_src_btn, 'enable', 'on');
    
  % READ APPLICATION DATA USED FOR SCAN PARAMETERS
    motorHandles = getappdata(mainFig, 'actxHnd');
    confData= getappdata(mainFig, 'confPar');
    maxSpeedNormal= str2num(confData.motor.maxspeednormal);
    maxSpeedLow= str2num(confData.motor.maxspeedlow);
    accelNormal= str2num(confData.motor.accelerationnormal);
    accelerationLow= str2num(confData.motor.accelerationlow);
    Xsteps= round(str2num(confData.application.rs_nstepsx));
    deltaX= str2num(confData.application.rs_deltax);
    deltaY= str2num(confData.application.rs_deltay);
    deltaZ= str2num(confData.application.rs_deltaz);
    Zsteps= round(str2num(confData.application.rs_nstepsz));
    slowSrchCheck= getappdata(mainFig, 'slowSrchCheck');
    slowFlag= slowSrchCheck.Value;
    
  % Initialize array to user values
    nMotors= numel(motorHandles)-1;
    if slowFlag
        maxSpeedMotor(1:nMotors) = maxSpeedLow;
        accMotor(1:nMotors) = accelerationLow;
    else
        maxSpeedMotor(1:nMotors) = maxSpeedNormal;
        accMotor(1:nMotors) = accelNormal;
    end
  
  % SET SCAN SPEED
    GUI_setVelocityParameters(mainFig, maxSpeedMotor, accMotor);

    
  % SCAN PARAMETERS
    focusPos= 22.53;
    camPos= 20.1;
    Sy_start= 10.;
    %Sy_stop= 9.5;
    %deltaY= 1.0; % 30 um per step
    Ysteps= 20;
    Sx_start= 20.4;
    %deltaX= 0.08;
    %Xsteps= 20;%20
    %Zsteps=3;%3
    %deltaZ= -0.15;
    
  % STORE OLD POSITIONS
    for i=1:nMotors
        oldPos(i)= HW_getPos(motorHandles(i));
    end
  
  % SCAN Z
    for stepZ=1:Zsteps
        % Check flag to continue search or not
        searchFlag= getappdata(mainFig, 'isSearching');
        if (~searchFlag)
            break
        end
      % POSITION Sy AND F
        if oldPos(5) >= focusPos 
            HW_moveAbsolute(motorHandles(5), focusPos); % First move focus away, then Sy
            HW_moveAbsolute(motorHandles(2), Sy_start); 
        else % First move Sy
            HW_moveAbsolute(motorHandles(2), Sy_start);
            HW_moveAbsolute(motorHandles(5), focusPos);
        end
    
      % POSITION Sx AND Cx
        HW_moveAbsolute(motorHandles(4), camPos);
        HW_moveAbsolute(motorHandles(1), Sx_start);

      % SCAN Sx AND Sy
        for stepX= 1:Xsteps
             % Check flag to continue search or not
            searchFlag= getappdata(mainFig, 'isSearching');
            if (~searchFlag)
                break
            end
            donePerc= 100*(stepX+(stepZ-1)*Xsteps)/(Zsteps*Xsteps);
            buttonStr= ['<html>WAIT<br>' num2str(donePerc, '%3.1f') '%'];
            set(sourceBtn, 'string', buttonStr);
            if mod(stepX,2) == 1
                HW_moveAbsolute(motorHandles(2), Sy_start -deltaY/2);
                pause(0.3);
                HW_moveAbsolute(motorHandles(2), Sy_start -deltaY/2);
            else
                HW_moveAbsolute(motorHandles(2), Sy_start +deltaY/2);
                pause(0.3);
                HW_moveAbsolute(motorHandles(2), Sy_start +deltaY/2);
            end
            HW_moveRelative(motorHandles(1), -deltaX);
        end
        HW_moveRelative(motorHandles(3), deltaZ);
    end
    
    searchFlag= getappdata(mainFig, 'isSearching');
    if (searchFlag)
      % RETURN Z TO ITS ORIGINAL POSITION
        HW_moveAbsolute(motorHandles(3),  oldPos(3));

      % MOVE CUVETTE TO THE MAX POSITION?
        fprintf('MOVING CUVETTE TO MAXIMUM INTENSITY POINT\n');
        posArray= GUI_readFileMaxPosition(mainFig);
        for i=1:5
             HW_moveAbsolute(motorHandles(i), posArray(i));
        end
    end
  % RESET SEARCH FLAG  
    setappdata(mainFig, 'isSearching', 0);
    
  % RESET SCAN SPEED TO DEFAULT VALUES
    GUI_setVelocityParameters(mainFig, [2.1 2.1 2.1 2.1 2.1], [1.4 1.4 1.4 1.4 1.4]);
    
  % DISABLE ABORT BUTTON
    abort_src_btn= getappdata(gcf, 'abort_src_btn');
    set(abort_src_btn, 'enable', 'off');  
    
  % ENABLE BUTTON
    set(sourceBtn, 'string', '<HTML><FONT size="-1">ROOT<br>SEARCH');
    set(sourceBtn, 'enable', 'on');
    toc()
end

