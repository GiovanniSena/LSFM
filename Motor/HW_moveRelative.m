function [] = HW_moveRelative(actxHandle, distance)
%% Defined in APT_GUI_working.

    confData= getappdata(gcf, 'confPar');
    DEBUG= confData.application.debug;
    %get(actxHandle)
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
    
    
    %pause(2); % Needed until I sort out the "isMoving" issue.
    
    
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
        if (DEBUG) disp('MOVE DONE'); end 
    else
        myWarning= 'Time out before reaching final position';
        warning(myWarning);
    end
end
    
    
    
%     
%     timeout = 2; %% timeout for waiting the move to be completed. Max 18 s for 25 mm travel.
%     t1 = clock; % current time
%     while(etime(clock,t1)<timeout) 
%     % wait while the motor is active; timeout to avoid dead loop
%         s = actxHandle(actuator).GetStatusBits_Bits(0);
%         if (IsMoving(s) == 0)
%           pause(0.1); % small pause when reached destination;
%           break;
%         end
%     end



 
