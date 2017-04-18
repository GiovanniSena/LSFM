function GUI_adjustTracking(mainFig, source)
 %% GUI_ADJUSTTRACKING Tell the code to not consider previous stack for trakcing purposes
 %  During the tracking, we might need to manually adjust the cuvette
 %  position. If we do it, we need to tell the code that the cuvette is now
 %  in a different position with respect to what the tracking thinks and
 %  therefore the next stack should not be compared with the previous one.
 %  When this function is executed, a flag is set to zero. This flas is
 %  used in "start_call" to assess whether we need to perform or skip the
 %  tracking.
    
    fprintf('Cuvette position was manyally adjusted. Tracking will be skipped for next iteration.\n');
    setappdata(mainFig, 'usePreviousScan', 0);

end

