function updateTime(~, ~,  startScanTime, indicatorHandle )
%%  UPDATETIME Track time since last update of tracking data
%  

    secondsInAMinute = 60;
    secondsInAnHour  = 60 * secondsInAMinute;
    secondsInADay    = 24 * secondsInAnHour;
    
    elapsedTime = toc(startScanTime);
%   extract days
    days = floor(elapsedTime / secondsInADay);
%   extract hours
    hourSeconds = rem(elapsedTime , secondsInADay);
    hours = floor(hourSeconds / secondsInAnHour);
%   extract minutes
    minuteSeconds = rem(hourSeconds , secondsInAnHour);
    minutes = floor(minuteSeconds / secondsInAMinute);

%   extract the remaining seconds
    remainingSeconds = rem(minuteSeconds , secondsInAMinute);
    seconds = floor(remainingSeconds);
    
    text = sprintf('%02d:%02d:%02d:%02d', days, hours, minutes, seconds);
    
    set(indicatorHandle, 'string', text);
end



    