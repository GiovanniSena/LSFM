function [ yFocus ] = tr_autofocus( afSpacing, motor, video_obj )
 %% TR_AUTOFOCUS Routing to find best focus position
 %   Take a snapshot from current position of camera, then take 4 more
 %   snapshots, positioned 1, 2, -1 and -2 steps away from center. Size of
 %   step is defined by afSpacing.

    confData= getappdata(gcf, 'confPar');
    avg_sampleaf= str2double(confData.user.avg_sampleaf);
    DEBUG= confData.application.debug;
    
    if (DEBUG)
        disp('AUTOFOCUS, please wait...');
        disp(['AF Spacing= ' num2str(afSpacing) ' mm']);
    end
    
 % GET INITIAL POSITION
    initPos= HW_getPos(motor);

 % TAKE N PICTURES (N= samples)
    PosAF= [-3, -2, -1, 0, +1, +2, +3]; % Original was [-3, -2, -1, 0, +1, +2, +3]. Reduced to reduce laser time.
    %PosAF= [0, +1, +2, -1, -2 ];
    [~, samples]= size(PosAF);
    sharpVal=zeros(samples, 1);
    sharpVal= sharpVal';
    for i= 1:samples    
     % MOVE TO POSITION
        newPos= initPos + PosAF(i)*afSpacing;
        HW_moveAbsolute(motor, newPos);
        myMsg= ['AF: move relative= ' num2str(PosAF(i)) ' steps (step size= ' num2str(afSpacing) ')'];
        if (DEBUG) disp(myMsg); end %#ok<SEPEX>
        
     % TAKE SNAPSHOT
        %myPicture =  camera_snapshot(video_obj);
        myPicture =  camera_snapshot_avg(video_obj, avg_sampleaf); %AVERAGE N SNAPS
     
     % TAKE SUBSET OF SNAPSHOT (actually, it is better if we do not)
        af_x= str2double(confData.camera.af_y);
        af_y= str2double(confData.camera.af_x);
        af_w= str2double(confData.camera.af_h);
        af_h= str2double(confData.camera.af_w);
        [yDim, xDim, zDim]=size(myPicture);
        afx_i= round(xDim*af_x+1); %THIS IS CORRECT: what I call X in preview is Y in saved image
        afx_f= round(xDim*(af_x + af_w));
        afy_i= round(yDim*af_y+1);
        afy_f= round(yDim*(af_y+ af_h));
        
        %myPictureROI=myPicture(afy_i:afy_f, afx_i:afx_f );
        
        %myPicture= myPicture - 0; % REMOVE NOISY PIXELS (questionable...)
        %myPicture = imadjust(myPicture); % ADJUST DYNAMIC RANGE
        
        
     % CALCULATE SHARPNESS ON WHOLE IMAGE
        sharpVal(i)= fmeasure(myPicture, 'GDER', []);% <- HERE I AM USING THE WHOLE FRAME, NOT ROI
        myMsg= ['Sharpness ' num2str(i) '= ' num2str(sharpVal(i))];
        if(DEBUG) disp(myMsg); end %#ok<SEPEX>
    end
    
 % NOW PICK BEST VALUE AND POSITION CAMERA THERE
    [maxSharp, maxPos]= max(sharpVal(:));
    yFocus= initPos + PosAF(maxPos)*afSpacing;
    
    myMsg= ['Best sharpness found at ' num2str(yFocus) ' (value= ' num2str(maxSharp) '; step= ' num2str(maxPos) '): positioning camera there.'];
    disp(myMsg);
    HW_moveAbsolute(motor, yFocus);
    if (DEBUG) disp('...AUTOFOCUS Done!'); end %#ok<SEPEX>
    
    finePos= tr_interpolateFocusPos(PosAF, sharpVal);
    
    newPos= initPos + finePos*afSpacing;
    disp(['FINE POS= ' num2str(finePos) ' NEW POS= ' num2str(newPos)]);
    HW_moveAbsolute(motor, newPos);
    
    
    
    
end

