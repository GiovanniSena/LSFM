function camera_close( video_obj, video_src )
    %Release the resources for the camera
    % 
    try
        delete(video_obj);
        %delete(video_src);
        clear video_obj;
        clear video_src;
        disp('CAMERA CLOSE');
        %imaqreset Reset all cameras (useful if resource is locked)
    catch
        disp('Error closing camera');
    end
end

