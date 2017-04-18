function [ collisionTimer ] = timer_createCollision( mainFig, CollisionInd )
 %% TIMER_CREATECOLLISION Create timer to regularly check motor position and avoid collision between cuvette and objective.
 %  Period is 500 ms.

    collisionTimer= timer;
    
    collisionTimer.StartDelay = 0;
    collisionTimer.Period = 0.5;
    collisionTimer.ExecutionMode = 'fixedRate';
    
    collisionTimer.TimerFcn = {@timer_updateDistance, mainFig, CollisionInd};
    %collisionTimer.StartFcn = @initTempTimer;
    %collisionTimer.StopFcn = {@stopTempTimer, mainFig, CollisionInd};
    setappdata(mainFig, 'collisionTimer', collisionTimer);
end

