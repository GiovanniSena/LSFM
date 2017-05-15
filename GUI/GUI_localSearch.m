function [ output_args ] = GUI_localSearch( mainFig, sourceBtn )
%%  GUI_ROOTSEARCH Performs a root search near the current coordinates
%   This function search for a maximum in the preview intensity to identify
%   the location of the root. The search is performed by moving the cuvette
%   in X, Y and Z and measuring the global intensity of the image.
    
    fprintf('LOCAL SEARCH MACRO ACTIVATED\n');
    setappdata(mainFig, 'isSearching', 1);
    setappdata(mainFig, 'maxSearch', 0);
    
    tic()
  % DISABLE BUTTON
    oldString= get(sourceBtn, 'string');
    set(sourceBtn, 'string', '<HTML><FONT size="-1">WAIT');
    set(sourceBtn, 'enable', 'off');
    
  % ENABLE ABORT BUTTON
    abort_src_btn= getappdata(gcf, 'abort_src_btn');
    set(abort_src_btn, 'enable', 'on');
    
  % READ APPLICATION DATA USED FOR SCAN PARAMETERS
    motorHandles = getappdata(mainFig, 'actxHnd');
    confData= getappdata(mainFig, 'confPar');
    maxSpeedNormal= str2num(confData.motor.maxspeednormal);
    safedist = str2double(confData.motor.safedist_fy);
    maxSpeedLow= str2num(confData.motor.maxspeedlow);
    accelNormal= str2num(confData.motor.accelerationnormal);
    accelerationLow= str2num(confData.motor.accelerationlow);
    Xsteps= round(str2num(confData.application.ls_nstepsx));
    deltaX= str2num(confData.application.ls_deltax);
    deltaY= str2num(confData.application.ls_deltay);
    deltaZ= str2num(confData.application.ls_deltaz);
    Zsteps= round(str2num(confData.application.ls_nstepsz));
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
    
    oldPos(1:nMotors)=0;
  % STORE OLD POSITIONS
    for i=1:nMotors
        oldPos(i)= HW_getPos(motorHandles(i));
    end
    
  % SCAN STARTING POINT
    focusPos= oldPos(5);
    camPos= oldPos(4);
    Sy_start= oldPos(2);
    Sx_start= oldPos(1) + Xsteps*deltaX/2;
  
  % SCAN Z
    for stepZ=1:Zsteps
        % Check flag to continue search or not
        searchFlag= getappdata(mainFig, 'isSearching');
        if (~searchFlag)
            break
        end
      % POSITION Sy (but check to avoid collision)
        attemptDist= safedist - (Sy_start + focusPos);
        minimumAcceptedDist= 0.3;
        if (attemptDist > minimumAcceptedDist + deltaY/2)
            HW_moveAbsolute(motorHandles(2), Sy_start); 
          % POSITION Sx
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
        else
            fprintf('The current choice of scan parameters will cause the cuvette to be at %1.2f mm from the objective (minimum accepted is %1.2f mm). Scan aborted.\n', attemptDist-deltaY/2, minimumAcceptedDist);
            break
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
    set(sourceBtn, 'string', oldString);
    set(sourceBtn, 'enable', 'on');
    toc()
end

