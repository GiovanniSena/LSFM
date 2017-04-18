function [ mainTimer ] = timer_createMain( varargin)
%% TIMER_CREATETEMP Summary of this function goes here
%   Detailed explanation goes here
    

% TO BE FIXED!!!!
    mainTimer = timer;
    
    setappdata(gcf, 'mainTimer', mainTimer);
            
    

    
    mainTimer.StartDelay = 0;
    mainTimer.Period = 1;
    mainTimer.ExecutionMode = 'fixedRate';
    mainTimer.TimerFcn = {@updateTime, startScan, getappdata(mainFig, 'totalTimeInd')};
    
    mainTimer.TimerFcn = @updateTemperature;
    mainTimer.StartFcn = @initTempTimer;
    setappdata(gcf, 'temperatureTimer', mainTimer);

end

