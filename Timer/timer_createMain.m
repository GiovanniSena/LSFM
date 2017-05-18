function [ mainTimer ] = timer_createMain( varargin)
%%  TIMER_CREATETEMP Create timer for "total time elapsed" indicator
%   The times is used by the GUI to provide an estimate of the total time
%   the automated scan has been active.
    

%   Define parameters
    mainTimer = timer;
    setappdata(gcf, 'mainTimer', mainTimer);
    mainTimer.StartDelay = 0;
    mainTimer.Period = 1;
    mainTimer.ExecutionMode = 'fixedRate';
    mainTimer.TimerFcn = {@updateTime, startScan, getappdata(mainFig, 'totalTimeInd')};
    mainTimer.TimerFcn = @updateTemperature;
    mainTimer.StartFcn = @initTempTimer;
%   Write handle in GUI data
    setappdata(gcf, 'temperatureTimer', mainTimer);
end

