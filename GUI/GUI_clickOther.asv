function GUI_clickOther(source, ~, ~)
 %% GUI_clickMove: executed when one of the manual move buttons is pressed.
 %
  
  % RETRIEVE THE NAME OF THE PARENT FIGURE FOR THE BUTTON
    mainFig= GUI_getParentFigure(source);
    confData= getappdata(mainFig, 'confPar');
    %confData= getappdata(mainFig, 'confPar');
    DEBUG= confData.application.debug;
    
    
    
    defColor= get(source, 'BackgroundColor'); %
    set(source, 'BackgroundColor', 0.9*defColor); % Button is disabled, so we change color manually
    
    %clickType= get(gcf,'SelectionType'); % normal (left click), open (double click), extend (shift + left click) or alt (right click or ctrl + left click)
    
    % Check which button was pressed and determine what motor to use.

    buttonPressed = get(source, 'Tag');
    if (DEBUG)
        disp(['Button: ', buttonPressed, ' CLICKED']);
    end
    
    switch buttonPressed
        case 'OPEN_SH'
            motorHandles = getappdata(mainFig, 'actxHnd');
            motor= motorHandles(6);
            GUI_shutterToggle(motor, 1);
        case 'CLOSE_SH'  
            motorHandles = getappdata(mainFig, 'actxHnd');
            motor= motorHandles(6);
            GUI_shutterToggle(motor, 0);
        case 'LED_ON'
            GUI_LEDToggle(1);
        case 'LED_OFF'
            GUI_LEDToggle(0);
        case 'PUMP_ON'
            GUI_pumpToggle(1);
        case 'PUMP_OFF'
            GUI_pumpToggle(0);
        case 'PREV_ON'
            GUI_previewToggle(mainFig, 1);
        case 'PREV_OFF'
            GUI_previewToggle(mainFig, 0);
        case 'WEB_ON'
            GUI_webcamToggle_snaps(1);
        case 'WEB_OFF'
            GUI_webcamToggle_snaps(0);
        case 'SLICE'
            GUI_takeSlices(source, mainFig);
        case 'SNAP'
            GUI_takeSnapshot(source);
        case 'A_FOCUS'
            GUI_autofocus(source);
        case 'HOME'
            HW_home(mainFig);
        case 'FOCUS'
            GUI_sendtofocus(source);
        case 'SAVE_COORD'
            GUI_saveCoord(source);
        case 'LOAD_COORD'
            GUI_loadCoord(source);
        case 'SETUP'
            GUI_setup(source);
        case 'ROOT_SRC'
            GUI_rootSearch(mainFig, source);
        case 'LOCAL_SRC'
            GUI_localSearch(mainFig, source);
        case 'ADJUST'
            GUI_adjustTracking(mainFig, source);
        case 'ABORT_SRC'
            GUI_abortSearch(mainFig, source);
        case 'TMP' %for debugging
            %GUI_setVelocityParameters(mainFig, [2.1 2.1 2.1 2.1 2.1], [1.4 1.4 1.4 1.4 1.4]);
            HW_getVelocityParameters(mainFig);
        case 'BACKGROUND_SNAP' %
            GUI_bgrsnap(mainFig, source);
        otherwise
            disp('BUTTON UNKNOWN');
    end
    
    pause(0.1); % Pause to make sure we see the color change
    set(source, 'BackgroundColor', 'default'); % Return button to default color.    
    
end