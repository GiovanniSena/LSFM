function totalTime( startScanTime, indicatorHandle )
%%  TOTALTIME Tracks the total time elapsed
%  
    isScan =  getappdata(gcf, 'isScanning');
    elapsedTime = toc(startScanTime);
    
    set(getappdata(gcf, 'totalTimeInd'), 'string', elapsedTime);
    i=0;
end

