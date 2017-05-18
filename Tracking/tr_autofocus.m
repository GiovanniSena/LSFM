function [ yFocus ] = tr_autofocus( afSpacing, motor, video_obj )
%%  TR_AUTOFOCUS Routing to find best focus position
%   Take a snapshot from current position of camera, then take more
%   snapshots, positioned +N and -N steps away from center. Size of
%   step is defined by afSpacing.
%   At each step the image takes is averaged over a user-defined number of
%   snapshots (avg_sampleaf).

%   Retrieve parameters
    confData= getappdata(gcf, 'confPar');
    avg_sampleaf= str2double(confData.user.avg_sampleaf);
    DEBUG= confData.application.debug;
    
    if (DEBUG)
        disp('AUTOFOCUS, please wait...');
        disp(['AF Spacing= ' num2str(afSpacing) ' mm']);
    end
    
%   Get initial motor position
    initPos= HW_getPos(motor);

%   Take N readings to find best focus (N= samples)
    PosAF= [-3, -2, -1, 0, +1, +2, +3];
    %PosAF= [0, +1, +2, -1, -2 ];
    [~, samples]= size(PosAF);
    sharpVal=zeros(samples, 1);
    sharpVal= sharpVal';
    for i= 1:samples    
    %   Move to reading position
        newPos= initPos + PosAF(i)*afSpacing + i*0.00035;  %autofocus correction, TF May 2nd, 2017
        HW_moveAbsolute(motor, newPos);
        myMsg= ['AF: move relative= ' num2str(PosAF(i)) ' steps (step size= ' num2str(afSpacing) ')'];
        if (DEBUG) disp(myMsg); end %#ok<SEPEX>
        
    %   Take snapshots and average them
        myPicture =  camera_snapshot_avg(video_obj, avg_sampleaf); %AVERAGE N SNAPS

    %   The commented section below is an attempt to improve image quality.
    %   Uncomment to use.
%     %   Define subset of snapshot, i.e. a region of interest of the image
%         af_x= str2double(confData.camera.af_y);
%         af_y= str2double(confData.camera.af_x);
%         af_w= str2double(confData.camera.af_h);
%         af_h= str2double(confData.camera.af_w);
%         [yDim, xDim, zDim]=size(myPicture);
%         afx_i= round(xDim*af_x+1); %THIS IS CORRECT: what we call X in preview is Y in saved image
%         afx_f= round(xDim*(af_x + af_w));
%         afy_i= round(yDim*af_y+1);
%         afy_f= round(yDim*(af_y+ af_h));
%     %   Extract ROI from image based on subset define aboce
%         myPictureROI=myPicture(afy_i:afy_f, afx_i:afx_f );
%     %   Remove pedestal
%         myPicture= myPicture - 0;
%     %   Adjust picture dynamic range
%         myPicture = imadjust(myPicture);
        
        
    %   Calculate sharpness (focus) of image at current position and store
    %   it in array sharpVal
        sharpVal(i)= fmeasure(myPicture, 'GDER', []);
        myMsg= ['Sharpness ' num2str(i) '= ' num2str(sharpVal(i))];
        if(DEBUG) disp(myMsg); end %#ok<SEPEX>
    end
    
%   Pick best value for focus. Use it to define the best camera position.
    [maxSharp, maxPos]= max(sharpVal(:));
    yFocus= initPos + PosAF(maxPos)*afSpacing;
    myMsg= ['Best sharpness found at ' num2str(yFocus) ' (value= ' num2str(maxSharp) '; step= ' num2str(maxPos) '): positioning camera there.'];
    disp(myMsg);
%   Position motor in best location by interpolating focus values 
    HW_moveAbsolute(motor, yFocus);
    if (DEBUG) disp('...AUTOFOCUS Done!'); end %#ok<SEPEX>    
    finePos= tr_interpolateFocusPos(PosAF, sharpVal); % the best focus could be between two of the steps taken
    
    newPos= initPos + finePos*afSpacing;
    disp(['FINE POS= ' num2str(finePos) ' NEW POS= ' num2str(newPos)]);
    HW_moveAbsolute(motor, newPos);
end

