function [previewImage] = camera_previewToggle( video_obj, previewImage, setStatus )
  %If setStatus = 1 starts the preview for the camera and writes it in the
  %prevContaine. If setStatus = 0 stops the currently runnign preview.
  %
    if (setStatus == 1)
     %prevImg= preview(video_obj, previewImage);
     %previewImage= 
         
        preview(video_obj, previewImage);
        
         
        %previewImage= imagesc(blankimage,'Parent', prevHaxes);

        disp('Preview started');
    else
        stoppreview(video_obj);
        disp('Preview stopped');
    end
end
