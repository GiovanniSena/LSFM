function GUI_start_call( ~, ~, mainFig )
 %% GUI_START_CALL Checks that everything is ok before actually starting the scan
 %
    confData= getappdata(mainFig, 'confPar');
    DEBUG= confData.application.debug;
    isScanning= getappdata(mainFig, 'isScanning');
    
    
 % PRE-SCAN CHECKS  
    if (isScanning == 1)
        myMsg= 'GUI_start_call: system already scanning';
        disp(myMsg);
    else
        isConfig = getappdata(mainFig, 'isConfig');
        if (isConfig == 0) % Check that user has set the config parameters
            msg = ['Set config parameters before scan (press CONFIGURATION and click "ACCEPT")'];
            errordlg(msg);
        else % If configured, then start the acquisition.
            isHome = getappdata(mainFig, 'isHome'); % Check if motors have been homed
            if (isHome == 0)
                choiceHome = questdlg('Motors not homed. Continue with scan?', ...
                'Motors', ... %TITLE
                'Scan','Home motors now', 'Scan'); %OPTION 1, OPTION 2, default
                switch choiceHome
                    case 'Scan'
                        disp('CONTINUE SCANNING');
                        setappdata(mainFig, 'isHome', 1);
                    case 'Home motors now'
                        disp('HOME THE MOTORS BEFORE SCAN');
                        HW_home(mainFig);
                    otherwise
                        disp('Ignore unknown choice');
                end
            end
            if (DEBUG)
                disp('START AUTOMATED TEST');
            end
            ScanInd = getappdata(mainFig, 'ScanInd');
            set(ScanInd, 'string', '<html>SCAN<br>ON');
            set(ScanInd, 'backgroundcolor', 'green');
        % Set isScanning flag, disable buttons
            setappdata(mainFig, 'isScanning', 1);
            setappdata(mainFig, 'isStopping', 0); %RESET STOP SIGNAL
            setappdata(mainFig, 'isPaused', 0); %RESET PAUSE SIGNAL
            pauseBtn= getappdata(mainFig, 'pauseBtn');
            set(pauseBtn, 'string', 'PAUSE'); %RESET PAUSE BUTTON
            set(getappdata(mainFig, 'configBtn'), 'enable', 'off');
            set(getappdata(mainFig, 'startBtn'), 'enable', 'off');
            set(getappdata(mainFig, 'stopBtn'), 'enable', 'on');
            startScan = tic;
        % Create timer for TOTAL TIME indicator
            mainTimer = timer('StartDelay', 0, 'Period', 1,  'ExecutionMode', 'fixedRate');
            mainTimer.TimerFcn = {@updateTime, startScan, getappdata(mainFig, 'totalTimeInd')};
            setappdata(mainFig, 'mainTimer', mainTimer);
            start(mainTimer);
        % Create timer for temperature update
            temperatureTimer = timer_createTemp(mainFig);
            start(temperatureTimer);
            % BEGIN SCAN
            %=========================================


            start_call(mainFig);




            %END OF SCAN
            %=========================================
            stop(mainTimer);
            delete(mainTimer);
            stop(temperatureTimer);
            delete(temperatureTimer);
            rmappdata(mainFig, 'temperatureTimer');

            set(getappdata(mainFig, 'configBtn'), 'enable', 'on');
            set(getappdata(mainFig, 'startBtn'), 'enable', 'on');
            set(ScanInd, 'string', '<html>SCAN<br>OFF');
            set(ScanInd, 'backgroundcolor', 'default');
            setappdata(mainFig, 'isScanning', 0);
            if (DEBUG)
                disp('END AUTOMATED TEST');
            end

        end
    end
end

