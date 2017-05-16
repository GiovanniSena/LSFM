function start_call( mainFig )
 % START_CALL Start the acquisition process.  
 % commented by GS (28/10/2016)

 %%%% PARAMETERS
 
  % RETRIEVE PARAMETERS
    sinceScanTimeInd= getappdata(mainFig, 'sinceScanTimeInd'); % "SINCE SCAN" TIMER
    inScanTimeInd= getappdata(mainFig, 'inScanTimeInd'); % "IN SCAN" TIMER
    confData= getappdata(mainFig, 'confPar'); % APPLICATION DATA STRUCTURE. Gets the parameters from "mainfig" which was set up in Main (lines 9,12).
    ySpacing= str2num(confData.user.yspacing); % SPACING BETWEEN SLICES in mm !
    dtScan= (str2num(confData.user.dtscan))*60; % WAIT TIME BETWWEN SCANS IN SECONDS
    nImages= str2num(confData.user.nimages); % IMAGES PER SCAN
    avg_sample= str2num(confData.user.avg_sample); % AVERAGE SNAPSHOT PER IMAGE
    afspacing= str2num(confData.user.afspacing); % AUTOFOCUS SPACING
    runNumber= str2num(confData.user.run); % RUN NUMBER
    saveDir= confData.application.savedir; % DIRECTORY TO STORE IMAGES
    logDir= confData.application.logdir; % DIRECTORY TO STORE LOGS
    simulate= str2num(confData.application.simulate);
    xConversion= str2num(confData.camera.umtopixelx); % size of pixel in our X, in um!
    zConversion= str2num(confData.camera.umtopixelz); % size of pixel in our Z, in um!
	focusadjust=str2num(confData.user.f_fdeltay); %retrieves the value for deltaF as a function of the Y step, using the parameter from beads (liquid)
    tpsbeta= str2num(confData.application.tpscoefficient); % TPS/CUVETTE MOVEMENT RELATIONSHIP
    motorHandles = getappdata(mainFig, 'actxHnd'); % MOTOR HANDLES
    transftype= confData.application.transftype; % TRANSFORMATION USED FOR THE TRACKING (RIGID/TRANSLATION). 
    video_obj= getappdata(mainFig, 'vidobj'); 
    video_src= getappdata(mainFig, 'videosrc');
    avg_sample= str2double(confData.user.avg_sample);
  
  % SET PARAMETERS  
    setappdata(mainFig, 'usePreviousScan', 0);
    xy_scalefactor= 2; % REDUCE LINEAR DIMENSION OF IMAGES BY THIS FACTOR FOR TRACKING PURPOSES (refers to our XZ plane) ORIGINALLY 4
    
 % ARRAYS PLOTS
    x= [];
    y= [];
    z= [];
    cumulX_Ts= timeseries('cumulX_Ts');
    cumulY_Ts= timeseries('cumulY_Ts');
    cumulZ_Ts= timeseries('cumulZ_Ts');
    I_Ts= timeseries('I_Ts');    % For intensity
    dS_Ts= timeseries('dS_Ts');
    
    currTime= now;
    cumulX_Ts= cumulX_Ts.addsample('Time', currTime , 'Data', 0);
    cumulY_Ts= cumulY_Ts.addsample('Time', currTime , 'Data', 0);
    cumulZ_Ts= cumulZ_Ts.addsample('Time', currTime , 'Data', 0);
    I_Ts= I_Ts.addsample('Time', currTime , 'Data', 0);
    dS_Ts= dS_Ts.addsample('Time', currTime , 'Data', 0);
 
    
%%% CONDITIONS 

    % LOOP UNTIL STOPPED/PAUSED
    isStopping = getappdata(mainFig, 'isStopping');
    sinceScan= tic;
    nloops= 1;
    acquiredTp= 0; %Number of acquired time points
    
    % Pull the root back so that there is some space either side of the
    % root in Y. Adjust camera accordingly. Also take background picture 
    % for bgrdcheck.
    HW_moveRelative(motorHandles(2), -15*ySpacing); % Something like 60um is desirable, so alter for alterred Y spacing.
    HW_moveRelative(motorHandles(5), focusadjust*-15*ySpacing); % Move F using calibration in liquid. Make sure the digit used is the same as for above.
    % Take a snap shot
    myPicture =  camera_snapshot_avg(video_obj, avg_sample);    
    % Calculate background
    [ T, BW, BWf, ttl_area ]= bgrcheck(myPicture);
    setappdata(mainFig, 'bgrarea', ttl_area);
    fprintf('Background objects area (%f) stored\n', ttl_area);
    
    while(isStopping ~= 1)  
        isPaused = getappdata(mainFig, 'isPaused');
        isStopping = getappdata(mainFig, 'isStopping');
        
      % CONDITION TO STOP
        if (isStopping == 1)
            myMsg= 'STOPPING NOW!';
            disp(myMsg);
            break;
        end
        
      % CONDITION TO PAUSE
        if (isPaused ==1)
            while (isPaused ==1)
                isPaused = getappdata(mainFig, 'isPaused');    
                pause(3);
                myMsg= 'SCAN PAUSED';
                disp(myMsg);
            end
        end

      % CONDITION TO SCAN  
        if (toc(sinceScan) > dtScan) || (nloops==1) % TAKE A SCAN
            sinceScan= tic; % RESET SINCE SCAN TIMER
            inScan= tic;
          % Create timer for INSCAN TIME indicator
            inScanTimer = timer('StartDelay', 0, 'Period', 1,  'ExecutionMode', 'fixedRate');
            inScanTimer.TimerFcn = {@updateTime, inScan, inScanTimeInd};
            setappdata(mainFig, 'inScanTimer', inScanTimer);
            start(inScanTimer);
          
%%%% START SCANNING %%%%%%%
      
          % PREVIEW ON
            GUI_previewToggle( mainFig, 1 );  
          % LED OFF
            GUI_LEDToggle(0);
          % SHUTTER OPEN
            GUI_shutterToggle(motorHandles(6), 1); 
          
            pause(5);
            stackName= tr_createStackName(runNumber, acquiredTp);
            
            if (~simulate) % do the following if you are NOT in simulation mode
                usePrevScan= getappdata(mainFig, 'usePreviousScan');
                if (usePrevScan==0) % if this is the first scan
                    oldStack= tr_takeSlices(mainFig, stackName); %current stack is called "oldstack"
                    %[MIPmean, MIPstDev]=GUI_displayMIP(mainFig,oldStack);%commented out by todd
                    GUI_displayMIP(mainFig, oldStack); %removed the save parameters, or else, the function won't display
                    
                else  % if this is not the first scan
                    newStack= tr_takeSlices(mainFig, stackName); %current stack is called "newstack"
                    %[MIPmean, MIPstDev]=GUI_displayMIP(mainFig,newStack);%Commented out by todd
              
                
                    GUI_displayMIP(mainFig, newStack);  %removed the save parameters, or else, the function won't display
                    

                end
                acquiredTp= acquiredTp+1; %Increase counter for acquired time point
            else  % do the following if you are NOT in simulation mode
                pause(120); % wait 2 minutes (laser on cuvette)
            end
            

          % PREVIEW O
           %GUI_previewToggle( mainFig, 0 );  %if we want to have the preview show the last MIP, we have to change this here
                                              %and keep the preview on, but
                                              %just showing the last MIP,
                                              %not overwriting it.  -TF
          % LED ON
            GUI_LEDToggle(1);
          % SHUTTER CLOSED
            GUI_shutterToggle(motorHandles(6), 0);
            
%%%% END SCANNING %%%%%%%

%%%% TRACKING %%%%%%%
            
            usePrevScan= getappdata(mainFig, 'usePreviousScan');
            if (usePrevScan==1)   % if this is NOT the first scan
                if (~simulate) % do the following if you are NOT in simulation mode
                    
                     %  TRIM outer parts of the stack (in X,Y and Z), to get rid of black regions coming from virtual tracking (see below)
                % 60 pixels on both ends in X and in Y
                % 5 slices on both ends in Z
                    oldStack_trim= oldStack(151:end-150, 221:end-220, 6:end-5); % Original was much less trimmed (only 1 each side in Y). Removing more decreases the likelihood of empty black slices resulting from virtual translation remaining.
                    trimName=strrep(stackName, '.tif', '_oldtrim.tif'); % to view the trimmed stack, to see if enough is trimmed. Remove once tracking working well.
                    trimPath= strcat( saveDir , '\_oldtrim\', trimName);
                    TIFF_writeStack(oldStack_trim, trimPath);
                    newStack_trim= newStack(151:end-150, 221:end-220, 6:end-5); 
                  
                  % RESCALE IMAGES FOR THE TRACKING ALGORITHM 
                    oldStack_small= tr_resizeStack(oldStack_trim, xy_scalefactor, 1);
                    newStack_small= tr_resizeStack(newStack_trim, xy_scalefactor, 1);
                

                  %%% FIND AFFINE TRANSFORMATION
                    best_A= eye(4); % define identity transformation
                    % best_A= tr_findTransfMatlab_mine(oldStack_small, newStack_small, transftype, zConversion*xy_scalefactor, xConversion*xy_scalefactor, ySpacing,  best_A);
                    
            % N.B. xConversion and zConversion are in um, ySpacing is in mm
            % but I want all in mm (output in mm, used by motors: line 152-154
            % also use xy_scalefactor (used in line 127-129) because image I use now has x,y pixels bigger than ones in original image
                    Xmm_pxl=xConversion/1000*xy_scalefactor;
                    Zmm_pxl=zConversion/1000*xy_scalefactor;
                    best_A= tr_findTransfMatlab_mine(oldStack_small, newStack_small, transftype, Zmm_pxl, Xmm_pxl, ySpacing, best_A);
                    % refers to this function:
                    % tr_findTransfMatlab_mine(prevStack, curStack, tType, xmm_pixel, ymm_pixel, zmm_pixel, best_A) where x,y is a pixels and z is stack dimension.
                    
                    IO_writeLogMatrix(logDir, stackName, best_A);
                    thetaX= atan2(-best_A(3,2) , best_A(3,3));
                    thetaY= atan2( best_A(3,1) , sqrt( power(best_A(3,2),2)+power(best_A(3,3),2) ));
                    thetaZ= atan2(-best_A(2,1) , best_A(1,1));
                    deltaX= best_A(4,2); % in mm, used by motors
                    deltaY= best_A(4,3); % in mm, used by motors
                    deltaZ= best_A(4,1); % in mm, used by motors
                    fprintf('DELTA_X CALCULATED= %3.2f um\n', deltaX*1000);
                    fprintf('DELTA_Y CALCULATED= %3.2f um\n', deltaY*1000);
                    fprintf('DELTA_Z CALCULATED= %3.2f um\n', deltaZ*1000);
                    fprintf('ThetaX= %1.3f (%2.1f deg)\n', thetaX, radtodeg(thetaX));
                    fprintf('ThetaY= %1.3f (%2.1f deg)\n', thetaY, radtodeg(thetaY));
                    fprintf('ThetaZ= %1.3f (%2.1f deg)\n', thetaZ, radtodeg(thetaZ));

                  % MOVE CUVETTE ACCORDING TO REGISTRATION RESULTS  
                    % Check that the Y movement does not collide with objective.
                    isSafe= tr_isMovingSafe(mainFig, deltaY);
                    if (isSafe==1)
                        HW_moveRelative(motorHandles(2), deltaY); % MOVE Y
                    else
                        warning('THE TRACKING IS TRYING TO POSITION THE CUVETTE TOO CLOSE TO THE OBJECTIVE');
                    end
                    
                    HW_moveRelative(motorHandles(5),  focusadjust*deltaY) % MOVE F because of light path change
                    disp('Camera moved to compensate for light path change');
                    HW_moveRelative(motorHandles(3), deltaZ); % MOVE Z
                    tr_correctXTPS(motorHandles, deltaX, tpsbeta); % MOVE X
                    disp('DUM DEH DUM I AM SCANNING');
                    
                  % Calculate mean intensity of stack to add to time
                  % series
                  oldInt= mean(oldStack(:));

                  % VIRTUALLY MOVE CURRENT STACK ACCORDING TO THE SAME TRANSLATION APPLIED TO THE STAGE (this translated image will be used in the next comparison for tracking)
                    RAinv = imref3d(size(newStack),  zConversion/1000, xConversion/1000, ySpacing);
                    effective_A= eye(4); %NEW UNITARY TRANSFORMATION
                    effective_A(4,2)= best_A(4,2);
                    effective_A(4,3)= best_A(4,3);
                    %effective_A(4,3)= 0; %UNCOMMENT THIS TO AVOID Y MOVEMENT
                    effective_A(4,1)= best_A(4,1);
                    oldStack= tr_transformCurrentStack( newStack, effective_A, RAinv );
                    %save virtual translated image
                    modName=strrep(stackName, '.tif', '_virt.tif'); % to view the trimmed stack, to see if enough is trimmed. Remove once tracking working well.
                    modPath= strcat( saveDir , '\_virt\', modName);
                    TIFF_writeStack(oldStack, modPath);
                   
                else  % do this if you are in simulate mode
                    deltaX= 1;
                    deltaY= 2;
                    deltaZ= 1.5*rand();
                end
                % UPDATE TIME SERIES
                    currTime= now;
                    cumulX_Ts= cumulX_Ts.addsample('Time', currTime , 'Data', cumulX_Ts.data(end)+deltaX);
                    cumulY_Ts= cumulY_Ts.addsample('Time', currTime , 'Data', cumulY_Ts.data(end)+deltaY);
                    cumulZ_Ts= cumulZ_Ts.addsample('Time', currTime , 'Data', cumulZ_Ts.data(end)+deltaZ);
                    I_Ts= I_Ts.addsample('Time', currTime , 'Data', oldInt);
                    dS_Ts= dS_Ts.addsample('Time', currTime , 'Data', dS_Ts.data(end)+sqrt(deltaX*deltaX+deltaY*deltaY+deltaZ*deltaZ));
                % PLOT TIME SERIES
                    GUI_updatePlots(mainFig, cumulX_Ts, cumulY_Ts, cumulZ_Ts, I_Ts);
                    
            end
            setappdata(mainFig, 'usePreviousScan', 1);
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

          
          
          
            
            stop(inScanTimer); % STOP IN SCAN TIMER
            set(inScanTimeInd, 'string', '--');
        end
        updateTime(mainFig, mainFig, sinceScan, sinceScanTimeInd); % UPDATE "SINCE SCAN" TIMER
        nloops= nloops + 1;
        pause(1);
        
    end
  % LED OFF
    GUI_LEDToggle(0);
  % SHUTTER CLOSED
    GUI_shutterToggle(motorHandles(6), 0);
    
  % SET THE STOP BUTTON TO ITS ORIGINAL STATE  
    stopBtn=getappdata(mainFig, 'stopBtn');
    set(stopBtn, 'string', 'STOP');
    set(stopBtn, 'Enable', 'off');
    
    
end



