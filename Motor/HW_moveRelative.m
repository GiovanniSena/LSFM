function [] = HW_moveRelative(actxHandle, distance)
%%  HW_MOVEABSOLUTE Moves a motor to a position relative to the current one.
%   This function takes as input the ActiveX handle for one of the motors
%   and instructs the motor to move by "distance" with respect to the current location.
%   The final position must be in range [0, 24.95] mm to avoid end-of-range errors.
%   A timeout of 45 seconds is used to establish if an error occurred.

    confData= getappdata(gcf, 'confPar');
    DEBUG= confData.application.debug;
    minRange = 0.05;
    maxRange = 24.95;
 
    current = HW_getPos(actxHandle);
    target= current + distance;
    if ((target < minRange) || (target > maxRange)) % Prevent motor from reaching end of range
        textMsg = ' you tried to position the stage too close to the end of its range. Command ignored.';
        warning(textMsg);
    else
        if (DEBUG)
            text = ['Moving from ', num2str(current), ' to ', num2str(target), ' (incr= ', num2str(distance), ')'];
            disp(text);
        end 
        actxHandle.MoveJog(0,1); % Jog
        actxHandle.SetRelMoveDist(0, distance);
        actxHandle.GetRelMoveDist_RelDist(0);
        actxHandle.MoveRelative(0, false);
    end
    
    timeout = 45; % Max 45 seconds before timeout
    t1 = clock; % current time
    stillMoving= 1;
    while((etime(clock,t1)<timeout) && (stillMoving~=0 ))
%   wait while the motor is active; timeout to avoid dead loop
        status = HW_GetStatusReg(actxHandle);
        stillMoving= HW_isMoving(status);
        pause(0.1);
    end
    if (stillMoving == 0)
        if (DEBUG) disp('MOVE DONE'); end 
    else
        myWarning= 'Time out before reaching final position';
        warning(myWarning);
    end
end