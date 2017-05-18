function tr_sendtofocus( fdistance, CamMotor, SyMotor )
%%  TR_SENDTOFOCUS Routine to send camera to focus
%   Sends the camera to a "known" good focus distance.
%   When executed, the camera will be positioned a a distance "fdistance"
%   from the cuvette. This should ensure a focused image.
%   Useful for setup.

%   Retrieve parameters
    confData= getappdata(gcf, 'confPar');
    DEBUG= confData.application.debug;
    safedist= str2double(confData.motor.safedist_fy);
    if (DEBUG)
        disp('FOCUS, please wait...');
    end
    
%   Get initial position for cuvette and camera
    initPosCam= HW_getPos(CamMotor);
    initPosSy= HW_getPos(SyMotor);
    
%   Move to desired position. Ensure no collision occurs.
    if(fdistance <= safedist)
        newPosCam= fdistance - initPosSy;
        myMsg= ['Moving F from ' num2str(initPosCam) ' to ' num2str(newPosCam) ];
        HW_moveAbsolute(CamMotor, newPosCam);
        if (DEBUG) disp(myMsg); end %#ok<SEPEX>
        if (DEBUG) disp('...FOCUS Done!'); end %#ok<SEPEX>
    else
        disp('Focus distance is smaller than safe distance: please check values in the config file.');
    end
end