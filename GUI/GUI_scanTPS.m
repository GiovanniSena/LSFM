function GUI_scanTPS( source, ~, ~ )
%%  GUI_SCANTPS Performs a scan across the laser sheet to find the thinnest part
%   The function performs a scan in the following way:
%   - from current cuvette position, scan in Y moving Sy and F together in
%      steps (ySpacing)
%   - save images in stack, save coordinates in logfile
%   - move X to a new position by moving the stage with step CxSpacing
%      (repeat for N= CxSteps)
%   This is an utility function to determine the approximate location of
%   the Thinnes Part of the Sheet.
 
    disp('START TPS SCAN');
    source.Enable= 'off';
    source.String= 'WAIT';
    
%   RETRIEVE GLOBAL PARAMETERS
    confData= getappdata(gcf, 'confPar');
    video_obj= getappdata(gcf, 'vidobj'); 
    video_src= getappdata(gcf, 'videosrc');
    fNameField =getappdata(gcf, 'fNameField');
    fileName= get(fNameField, 'string');
    motorHandles = getappdata(gcf, 'actxHnd');
    DEBUG= confData.application.debug;
    saveDir= confData.application.savedir;
    logDir= confData.application.logdir;
    avg_sample= str2double(confData.user.avg_sample);
    
%   DEFINE SCAN PARAMETERS
    nSlices= 60; %60 IMAGES PER POSITION, SCANNING IN Y
    ySpacing= 0.0005; % DISTANCE BETWEEN SLICES (Positive spacing -> increase Sy)
    CxSpacing= 0.1; %0.1 FOV in X is 145 um (X stage corresponds to 1040 pixels in camera and Y in imageJ). (50 um move by 350 pixels)
    CxSteps= 1; % CUVETTE X size= 10 mm. CxSteps= 10 mm/ CxSPacing to cover all of it (maybe too much)
   
    motorLabArray = ['X', 'Y', 'Z', 'C', 'Focus', 'Shutter']; 
 
%   SAVE STARTING Sy AND F FOR LATER   
    initialSy= HW_getPos(motorHandles(2));
    initialF= HW_getPos(motorHandles(5));
  
%   START SCANNIN IN Cx   
    totalSteps= CxSteps*nSlices;
    for currentXStep=1:CxSteps
    %   READ CURRENT COORDINATES, WRITE THEM TO FILE TOGETHER WITH STACK NAME
        logString = '';
        for i= 1:5
            pos = HW_getPos(motorHandles(i)); 
            logString= [logString   motorLabArray(i)   '= '  num2str(pos, '%02.4f') '; ']; %#ok<AGROW>
        end
        fileSplit= strsplit(fileName, '.');
        fileNameScan = [char(fileSplit(1)) '_' num2str(currentXStep, '%03d') '.tif']; %NAME OF THE TIF FILE FOR STACK
        fileNameLog = [char(fileSplit(1)) '.txt']; %NAME OF THE LOG FILE
        logString = [fileNameScan '; ' logString, 'YSpacing= ' num2str(ySpacing, '%01.4f') ' mm \n']; %#ok<AGROW>
        if(DEBUG) disp(logString); end
        fid = fopen([logDir fileNameLog], 'a+');
        fprintf(fid, logString);
        fclose(fid);

    %   SCAN MOVING Sy AND F TOGETHER
        for currentSlice= 1:nSlices
            doneSteps= (currentXStep-1)*nSlices + currentSlice;
            source.String= ['<HTML>WAIT...<br>' num2str(100*doneSteps/totalSteps, '%2.1f') ' %'];
        %   WAIT FOR EXPOSURE TIME    
            pause(video_src.Exposure + 0.1);
        %   TAKE PICTURE
            myPicture =  camera_snapshot_avg(video_obj, avg_sample);
            TIFF_write(myPicture, [saveDir fileNameScan]);
            myMsg= ['SLICE ' num2str(currentSlice) ' OF ' num2str(nSlices)];
            disp(myMsg);
        %   MOVE CAMERA AND CUVETTE IN SAME DIRECTION
            HW_moveRelative(motorHandles(2), ySpacing);
            HW_moveRelative(motorHandles(5), -ySpacing);
        end
        
    %   NOW MOVE Cx and Sx in SAME DIRECTION, BRING BACK Sy AND F, THEN REPEAT SCAN
        HW_moveRelative(motorHandles(4), CxSpacing);
        HW_moveRelative(motorHandles(1), -CxSpacing); 
        HW_moveAbsolute(motorHandles(2), initialSy);
        HW_moveAbsolute(motorHandles(5), initialF);
        pause(1);
    end
    source.Enable= 'on';
    source.String= '<HTML>SCAN<br>TPS';
    disp('END TPS SCAN');
end

