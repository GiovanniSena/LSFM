function GUI_takeSnapshot( sourceBtn )
%%  GUI_TAKESNAPSHOT Take 1 picture and save it to file
%   Instructs the GUI that the user wants to acquire a single picture from
%   the camera.

    disp('TAKING SNAPSHOT');
    
    confData= getappdata(gcf, 'confPar');
    video_obj= getappdata(gcf, 'vidobj'); 
    video_src= getappdata(gcf, 'videosrc');
    DEBUG= confData.application.debug;
%   READ N SLICES AND SPACING
    saveDir= confData.application.savedir;
    logDir= confData.application.logdir;
    avg_sample= str2double(confData.user.avg_sample);
    motorHandles = getappdata(gcf, 'actxHnd');
    
%   READ FILE NAME
    fNameField =getappdata(gcf, 'fNameField');
    fileName= get(fNameField, 'string');
    if isempty(fileName)
        myError= ('Please specify a file name');
        errordlg(myError);
    else
        if (DEBUG)
            myMsg= [fprintf('Image will be saved in: \n') saveDir fileName];
            disp(myMsg);
        end
        pause(video_src.Exposure + 0.1);     
        myPicture =  camera_snapshot_avg(video_obj, avg_sample);
        TIFF_write(myPicture, [saveDir fileName]);
        
        logString = '';
        motorLabArray = ['X', 'Y', 'Z', 'C', 'Focus', 'Shutter']; 
        for i= 1:5
            pos = HW_getPos(motorHandles(i));
            logString= [logString   motorLabArray(i)   '= '  num2str(pos, '%02.4f') '; ']; %#ok<AGROW>
        end
        fileSplit= strsplit(fileName, '.');
        fileNameLog = [char(fileSplit(1)) '.txt']; %NAME OF THE LOG FILE
        logString = [fileName '; ' logString ' \n']; %#ok<AGROW>
        if(DEBUG) disp(logString); end
        fid = fopen([logDir fileNameLog], 'a+');
        fprintf(fid, logString);
        fclose(fid);
    end
       
    disp('SNAPSHOT DONE');
end