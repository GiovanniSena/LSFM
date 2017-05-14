function GUI_webcamToggle_snaps( state )
%%  GUI_WEBCAMTOGGLE Button call back for camera preview.
%   Use snapshots instead of stream
  
%   Retrieve webcam
    webcam = getappdata(gcf, 'webcam');
    
%   Retrieve webcam image container   
    webcamImage= getappdata(gcf, 'webcamImage');

%   Check if we have already created a timer object for the webcam
    timerName = 'webcamTimer';
    if (isappdata(gcf, 'webTimer'))
        webTimer= getappdata(gcf, 'webTimer');
    else
        webTimer = timer('StartDelay', 0, 'Period', 0.5,  'ExecutionMode', 'fixedRate', 'Name', timerName);
        webTimer.TimerFcn = {@web_previewToggle_snaps, webcam, webcamImage, state };
        setappdata(gcf, 'webTimer', webTimer);      
    end
    
    if( state==1)
        % CREATE TIMER AND START
        start(webTimer);
    else
        stop(webTimer);
    end
%   Retrieve webcam indicator on main GUI
    WebInd = getappdata(gcf, 'WebInd');
%   Set webcam indicator on main GUI and set the image container to display a solid color   
    if (state==1)
        set(WebInd, 'string', '<html>WEBCAM<br>ON');
        set(WebInd, 'backgroundcolor', 'green'); 
    else
        set(WebInd, 'string', '<html>WEBCAM<br>OFF');
        set(WebInd, 'backgroundcolor', 'default'); 
        blankimage = ones(1280,720,3);
        blankimage(:,:,3) = 0.8;
        set(webcamImage, 'CData', blankimage);
    end
end

