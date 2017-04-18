function [myStack]= tr_takeSlices(mainFig, fileName )
 %% TR_TAKESLICES Take N pictures, moving Sy after each snap, and save them to file
 %   
    
    fprintf('TAKING MANUAL SLICES\n');
    
    confData= getappdata(mainFig, 'confPar');
    video_obj= getappdata(mainFig, 'vidobj'); 
    video_src= getappdata(mainFig, 'videosrc');
    DEBUG= confData.application.debug;
    AFInd = getappdata(mainFig, 'AFInd');
 
 % Retrieve area of objects (none hopefully) in background image)
    bgrarea= getappdata(mainFig, 'bgrarea');
 % READ N SLICES AND SPACING
    nSlices= str2double(confData.user.nimages);
    camerax= str2double(confData.camera.camerax);
    cameray= str2double(confData.camera.cameray);
    %nSlices= 6;
    ySpacing= str2double(confData.user.yspacing);
    afinterval= str2double(confData.user.afinterval);
    afspacing= str2double(confData.user.afspacing);
    %afspacing=0.0020;
    %ySpacing= 0.0032;
    saveDir= confData.application.savedir;
    avg_sample= str2double(confData.user.avg_sample);
    safeDist= str2double(confData.motor.safedist_fy);
    camadjustroot=str2num(confData.user.f_fystep); % retrieves necessary delta F as function of delta Y, calibrated with a H2B:YFP root
    camadjustbgrd=str2num(confData.user.f_fystep); % retrieves necessary delta F as function of delta Y, calibrated with fluorescent beads
    logDir= confData.application.logdir;
 
 % PREALLOCATE EMPTY STACK   
    myStack= uint16(zeros(camerax, cameray, nSlices));
    
 % READ CURRENT COORDINATES (JUST Y and F)
    motorHandles = getappdata(mainFig, 'actxHnd');
    %motorF= motorHandles(5);
    currentF= HW_getPos(motorHandles(5));
    currentY= HW_getPos(motorHandles(2));
    if (DEBUG)
        myMsg= ['Current Positions: Y= ' num2str(currentY) '; F= ' num2str(currentF)];
        disp(myMsg);
    end
    
 % CHECK DISTANCE CUVETTE-OBJECTIVE
    finalY= (nSlices-1)*ySpacing + currentY;
    if ((finalY + currentF) >= safeDist)
        myError = ['Current parameters will bring objective in collision with cuvette. Move stages or change settings (tab AUTO, CONFIG), then try again. Final delta= ' num2str(-finalF-currentY+safeDist, '%0.3f') '; Current delta= ' num2str(-currentF - currentY +safeDist, '%0.3f')];
        errordlg(myError);
    else
     % READ FILE NAME
        if isempty(fileName)
            myError= ('Please specify a file name');
            errordlg(myError);
        else
            if (DEBUG)
                myMsg= ['N_slices= ' num2str(nSlices) '; Spacing= ' num2str(ySpacing) '; AvgFrames=' num2str(avg_sample)];
                disp(myMsg);
                myMsg= [fprintf('Stack will be saved in: \n') saveDir fileName];
                disp(myMsg);
            end
            
         % READ CURRENT COORDINATES, WRITE THEM TO FILE TOGETHER WITH STACK NAME
            motorLabArray = ['X', 'Y', 'Z', 'C', 'Focus', 'Shutter']; 
            logString = '';
            for i= 1:5
                pos = HW_getPos(motorHandles(i));
                logString= [logString   motorLabArray(i)   '= '  num2str(pos, '%02.4f') '; ']; %#ok<AGROW>
            end
            fileSplit= strsplit(fileName, '.');
            initialPosY= HW_getPos(motorHandles(2));
            initialPosF= HW_getPos(motorHandles(5));
            
            fileNameLog = [char(fileSplit(1)) '.txt']; %NAME OF THE LOG FILE
            logString = [fileName '; ' logString, 'YSpacing= ' num2str(ySpacing, '%01.4f') ' mm \n']; 
            if(DEBUG) disp(logString); end
            fid = fopen([logDir fileNameLog], 'a+');
            fprintf(fid, logString);
            fclose(fid);
        % LOOP AND TAKE SNAPSHOT
            for i=1:nSlices
                fprintf('TAKING IMAGE %d OF %d\n', i, nSlices);
                myPicture =  camera_snapshot_avg(video_obj, avg_sample);
                [ T, BW, BWf, ttl_area ]= bgrcheck(myPicture);
                bwName=strrep(fileName, '.tif', '_bw.tif');
                TIFF_write(myPicture, [saveDir bwName]);  % <<<<< JUST CHECKING THE IMAGE USED FOR AREA CALCULATION
                fprintf('30 largest objects area (%f) stored\n', ttl_area);
                if ttl_area>(2*bgrarea)              
                    HW_moveRelative(motorHandles(5), camadjustroot*ySpacing); % Use instead of/as well as  autofocus, uses empirically determined autofocus
                elseif ttl_area<(2*bgrarea)
                    HW_moveRelative(motorHandles(5), camadjustbgrd*ySpacing); % Use instead of/as well as  autofocus, uses empirically determined autofocus
                    if (afinterval~=0)
                        if mod(i,afinterval)==0 % autofocus every "afinterval" images (shall I do it at the first step too?)                       
                           if ttl_area>(2*bgrarea)
                            set(AFInd, 'string', '<html>AF<br>ON');
                            set(AFInd, 'backgroundcolor', 'green'); 
                            tr_autofocus(afspacing,  motorHandles(5), video_obj);
                            set(AFInd, 'string', '<html>AF<br>OFF');
                            set(AFInd, 'backgroundcolor', 'default');
                           end
                        end
                    end
                end
                myPicture =  camera_snapshot_avg(video_obj, avg_sample);
                myStack(:,:,i)= myPicture;
                TIFF_write(myPicture, [saveDir fileName]);
                pause(video_src.Exposure);
                %pause(0.5); %I SHOULD WAIT FOR AT LEAST EXPOSURE TIME HERE
                HW_moveRelative(motorHandles(2), ySpacing);
                %HW_moveRelative(motorHandles(5), camadjust*ySpacing); % Use instead of autofocus, uses empirically determined autofocus
                
            end
            
        % RETURN TO Sy AND F TO INITIAL POSITION
            HW_moveAbsolute(motorHandles(2), initialPosY);
            HW_moveAbsolute(motorHandles(5), initialPosF);
        end
       
    end
    

 
    fprintf('MANUAL SLICES DONE\n');
end

