function GUI_previewToggle( mainFig, state )
%%  GUI_PREVIEWTOGGLE Button call back for camera preview.
%   Toggle the preview stream from the camera.

    previewImage = getappdata(mainFig, 'previewImage');
    vidobj= getappdata(gcf, 'vidobj');
    videosrc= getappdata(mainFig, 'videosrc');
    
    brightSld= getappdata(mainFig, 'brightSld');
    videosrc.Exposure= brightSld.Value;
    
    camera_previewToggle(vidobj, previewImage, state);
    PreviewInd = getappdata(mainFig, 'PreviewInd');
    
    if (state==1)
        set(PreviewInd, 'string', '<html>PREV<br>ON');
        set(PreviewInd, 'backgroundcolor', 'green'); 
    else
        [res]= get(vidobj, 'VideoResolution');
        set(PreviewInd, 'string', '<html>PREV<br>OFF');
        set(PreviewInd, 'backgroundcolor', 'default');
        blankimage = ones(res(2), res(1), 1, 'uint8');
        set(previewImage, 'CData', blankimage);
    end
end

