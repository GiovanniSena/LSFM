function [stillMoving] = HW_home( source )
 %  Send all the motors to the HOME position. Set the shutter to OFF
 %  Waits until the home is complete before enabling the START button on main window.
 %  Returns 0 if homing is completed, 1 if timeout.
 
    %set(getappdata(source, 'startBtnHandle'), 'Enable', 'off');
    
    motorHandles = getappdata(source, 'actxHnd');
    confData= getappdata(gcf, 'confPar');
    DEBUG= confData.application.debug;
    
    
    if(DEBUG) display('Shutter is now CLOSED'); end
    display('HOMING... (wait; it can take up to 1 min)');
    motorHandles(6).SC_Disable(0);
    for i= 1: (numel(motorHandles)-1)
        motorHandles(i).MoveHome(0,0); % Move home
    end
    
    % The following code waits for the homing to finish
    timeout = 45; % Enough time to home from any point in range.
    t1 = clock; % current time
    
    stillMoving= 1;
    pause(1);
    while(etime(clock,t1)<timeout)
        % wait while the motor is active; timeout to avoid dead loop
        for i= 1: (numel(motorHandles)-1)
            s = HW_GetStatusReg(motorHandles(i));
            statusMotors(i) = HW_isHoming(s);  %#ok<*AGROW>
        end
        stillMoving = any(statusMotors);
        if (stillMoving == 0)
            set(getappdata(source, 'startBtnHandle'), 'Enable', 'on');
            break;
        end
    end
    %pause(5); %Needed until I fix the "isMoving" issue.
    
    if (stillMoving ==0)
        disp('HOMING COMPLETE');
        setappdata(gcf, 'isHome',1); %MOTOR HOME STATUS FLAG
    else
        disp('WARNING: HOMING NOT COMPLETED');
    end
end

