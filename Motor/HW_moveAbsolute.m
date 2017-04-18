function [] = HW_moveAbsolute(actxHandle, target)
    %get(actxHandle)
    confData= getappdata(gcf, 'confPar');
    DEBUG= confData.application.debug;
    
    minRange = 0.05;
    maxRange = 24.95;
    
    current = HW_getPos(actxHandle);
    
    if ((target < minRange) || (target > maxRange)) % Prevent motor from reaching end of range
        textMsg = ' you tried to position the stage too close to the end of its range. Command ignored.';
        warning(textMsg);
    else
        if (DEBUG)
            text = ['Moving from ', num2str(current), ' to ', num2str(target)];
            disp(text);
        end 
    
        actxHandle.MoveJog(0,1); % Jog
        actxHandle.SetAbsMovePos(0, target);
        actxHandle.MoveAbsolute(0, false);
    end
    
    timeout = 45; % Max 45 seconds before timeout
    t1 = clock; % current time
    stillMoving= 1;
    while((etime(clock,t1)<timeout) && (stillMoving~=0 ))
     % wait while the motor is active; timeout to avoid dead loop
        status = HW_GetStatusReg(actxHandle);
        stillMoving= HW_isMoving(status);
        pause(0.1);
    end
    
    if (stillMoving == 0)
        if (DEBUG) disp('MOVE DONE'); end  %#ok<SEPEX>
    else
        myWarning= 'Time out before reaching final position';
        warning(myWarning);
    end
    
end

 
