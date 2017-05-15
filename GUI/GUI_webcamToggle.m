function GUI_webcamToggle( state )
%%  GUI_WEBCAMTOGGLE Notify the GUI to switch the webcam on/off
%   If a webcam is installed, this function allows to turn it of/off   
  
%   Retrieve webcam
    webcam = getappdata(gcf, 'webcam');
    
%   Retrieve webcam image container   
    webcamImage= getappdata(gcf, 'webcamImage');
    web_previewToggle_snaps(webcam, webcamImage, state); % Use snapshots instead of stream

%   Retrieve webcam indicator on main GUI
    WebInd = getappdata(gcf, 'WebInd');
%   Set webcam indicator on main GUI and set the image container to display a solid color   
    if (state==1)
        set(WebInd, 'string', '<html>WEBCAM<br>ON');
        set(WebInd, 'backgroundcolor', 'green'); 
    else
        set(WebInd, 'string', '<html>WEBCAM<br>OFF');
        set(WebInd, 'backgroundcolor', 'default'); 
        blankimage = ones(200,200,3);
        blankimage(:,:,3) = 0.8;
        set(webcamImage, 'CData', blankimage);
    end
end

