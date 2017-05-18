function [ collisionTimer ] = timer_createCollision( mainFig, CollisionInd )
%%  TIMER_CREATECOLLISION Create timer to regularly check motor position and avoid collision between cuvette and objective.
%   This function creates the timer responsible for regularly polling the
%   coordinates of camera (F) and sample stage (Sy) to ensure that the objective
%   is not in contact with the cuvette.
%   Period is set to 500 ms to ensure a regular update.

%   Create timer
    collisionTimer= timer;
%   Timer parameters    
    collisionTimer.StartDelay = 0;
    collisionTimer.Period = 0.5;
    collisionTimer.ExecutionMode = 'fixedRate';
%   Assign timer function    
    collisionTimer.TimerFcn = {@timer_updateDistance, mainFig, CollisionInd};
%   Add timer handle to application data for GUI
    setappdata(mainFig, 'collisionTimer', collisionTimer);
end

