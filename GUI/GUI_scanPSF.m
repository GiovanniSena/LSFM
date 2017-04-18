function GUI_scanPSF( source, ~, ~ )
 %% GUI_SCANPSF Performs a scan moving the camera in steps (cuvette is fixed)
 %  The function performs a scan in the following way:
 %   
 
    disp('START PSF SCAN');
    source.Enable= 'off';
    source.String= 'WAIT';
    
    
 % RETRIEVE GLOBAL PARAMETERS
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
    %safeDist= str2double(confData.motor.safedist_fy);
    
 % DEFINE SCAN PARAMETERS
    nSlices= 50; %N IMAGES PER POSITION, SCANNING IN Y; default = 50
    ySpacing= 0.001; % DISTANCE BETWEEN SLICES (Positive spacing -> increase Sy); default = 0.001
    
    motorLabArray = ['X', 'Y', 'Z', 'C', 'Focus', 'Shutter']; 
 
 % SAVE STARTING F FOR LATER   
    initialF= HW_getPos(motorHandles(5));
  
 % START SCANNIN IN Cx   
    %currentXStep=1;
    
       currentXStep=0;
     % READ CURRENT COORDINATES, WRITE THEM TO FILE TOGETHER WITH STACK NAME
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

     % SCAN MOVING Sy AND F TOGETHER
        for currentSlice= 1:nSlices
            source.String= ['<HTML>WAIT...<br>' num2str(100*currentSlice/nSlices, '%2.1f') ' %'];
         % WAIT FOR EXPOSURE TIME    
            pause(video_src.Exposure + 0.1);
         % TAKE PICTURE
            myPicture =  camera_snapshot_avg(video_obj, avg_sample);
            TIFF_write(myPicture, [saveDir fileNameScan]);
            myMsg= ['SLICE ' num2str(currentSlice) ' OF ' num2str(nSlices)];
            disp(myMsg);
         % MOVE CAMERA IN Y
            HW_moveRelative(motorHandles(5), -ySpacing);
        end
     
        %HW_moveRelative(motorHandles(1), -CxSpacing); LEAVE CAMERA
        HW_moveAbsolute(motorHandles(5), initialF);

    
 

    source.Enable= 'on';
    source.String= '<HTML>SCAN<br>TPS';
    disp('END TPS SCAN');
end

