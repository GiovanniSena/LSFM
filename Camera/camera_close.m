function camera_close( video_obj, video_src )
%%  Release the resources for the camera
%   When execute, deletes the video object and release the resorces for the
%   camera, allowing it to be reuse by other processes or re-opened by the
%   next GUI.

    try
        delete(video_obj);
        clear video_obj;
        clear video_src;
        disp('CAMERA CLOSE');
    catch
        disp('Error closing camera');
    end
end

