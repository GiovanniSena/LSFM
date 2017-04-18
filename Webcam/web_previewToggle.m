function web_previewToggle( cam, webcamImage, setStatus )
 %WEB_PREVIEWTOGGLE Summary of this function goes here
 %   Detailed explanation goes here
    if (setStatus == 1)
        
        preview(cam, webcamImage);
        disp('Webcam ON');
    else
        closePreview(cam);
        disp('Webcam OFF');
    end

end
