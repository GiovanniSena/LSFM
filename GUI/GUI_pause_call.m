function GUI_pause_call( ~, ~, mainFig )
 %% GUI_PAUSE_CALL Toggle isPaused flag to 1 when called
 %  When the button is pressed, this function checks the current status of
 %  the system and toggles the isPaused variable to PAUSE/RESUME the
 %  current scan.
    
    currentStatus= getappdata(mainFig, 'isPaused');
    pauseBtn= getappdata(mainFig, 'pauseBtn');
    
    if currentStatus == 0
        myMsg= 'PAUSING';
        setappdata(mainFig, 'isPaused', 1);
        set(pauseBtn, 'string', 'RESUME');
    else
        myMsg= 'RESUMING';
        setappdata(mainFig, 'isPaused', 0);
        set(pauseBtn, 'string', 'PAUSE');
    end
    disp(myMsg);

end

