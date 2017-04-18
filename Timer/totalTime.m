function updateTime( startScanTime, indicatorHandle )
%% TOTALTIME Summary of this function goes here
%  
    isScan =  getappdata(gcf, 'isScanning');
    elapsedTime = toc(startScanTime);
    
    set(getappdata(gcf, 'totalTimeInd'), 'string', elapsedTime);
    i=0;
    
    %http://uk.mathworks.com/help/matlab/ref/timer-class.html
end

