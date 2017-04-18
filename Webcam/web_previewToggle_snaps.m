function web_previewToggle_snaps( ~, ~, cam, webcamImage, setStatus )
 %WEB_PREVIEWTOGGLE Summary of this function goes here
 %   Detailed explanation goes here
    if (setStatus == 1)
        
        %preview(cam, webcamImage);
        snapshotImage = snapshot(cam);
        
        set(webcamImage, 'CData', snapshotImage);
    else
        closePreview(cam);
        disp('Webcam OFF');
    end

end
