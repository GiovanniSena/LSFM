function [previewImage] = camera_previewToggle( video_obj, previewImage, setStatus )
%%  Switches the camera stream on/off
%   If setStatus = 1 starts the preview for the camera and streams it to the
%   prevContainer. If setStatus = 0 stops the currently running preview.

    if (setStatus == 1)
        preview(video_obj, previewImage);
        disp('Preview started');
    else
        stoppreview(video_obj);
        disp('Preview stopped');
    end
end
