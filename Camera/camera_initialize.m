function [video_obj, video_src] = camera_initialize(cam_name)
    %%Initialize the camera and returns the handles for the video object
    %%and video source.
    
        %Retrieve camera info
        cam_name = 'qimaging';
        try
            camera_info= imaqhwinfo(cam_name);

            video_obj= videoinput('qimaging'); %Create video input object CHANGE THIS IF YOU WANT TO SPECIFY A DIFFERENT RESOLUTION
            video_src = getselectedsource(video_obj); %Create video source
            %INITIAL CONFIGURATION
            video_src.Exposure= 0.15; % INITIAL EXPOSURE
            video_src.Cooling = 'on';
            disp('CAMERA OPEN');
        catch
            msg = ['Error while opening camera'];
            h = errordlg(msg);
            imaqreset;
        end
end