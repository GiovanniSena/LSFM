function [] = moveStage(~,~, actuator, distance)
global actxHandle;    %% Defined in APT_GUI_working.
    current = getPosition(actuator);
    target= current + distance;
    text = ['Moving ', num2str(actuator), ' from ', num2str(current), ' to ', num2str(target), ' (incr= ', num2str(distance), ')'];
    disp(text);
    
    actxHandle(actuator).MoveJog(0,1); % Jog
    % Move a absolute distance
    %actxHandle(actuator).SetAbsMovePos(0, target);%Perhaps better to use relative move?
    %actxHandle(actuator).MoveAbsolute(0, false);
    actxHandle(actuator).SetRelMoveDist(0, distance);
    actxHandle(actuator).GetRelMoveDist_RelDist(0)
    actxHandle(actuator).MoveRelative(0, false);
    
    
    timeout = 2; %% timeout for waiting the move to be completed. Max 18 s for 25 mm travel.
    t1 = clock; % current time
    while(etime(clock,t1)<timeout) 
    % wait while the motor is active; timeout to avoid dead loop
        s = actxHandle(actuator).GetStatusBits_Bits(0);
        if (IsMoving(s) == 0)
          pause(0.1); % small pause when reached destination;
          break;
        end
    end
end

function [currentPos] = getPosition(actuator)
global actxHandle;

      currentPos= actxHandle(actuator).GetPosition_Position(0);
       
end

 
