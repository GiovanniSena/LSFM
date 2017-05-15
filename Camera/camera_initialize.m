function [video_obj, video_src] = camera_initialize(cam_name)
%%  Initialize the camera
%   Creates a video object, initializes it and returns the handles for the video object and video source.
    
%   Retrieve camera info
    cam_name = 'qimaging';
    try
        camera_info= imaqhwinfo(cam_name);
    %   Create video input object. Must be changed to match the
    %   manufacturer's description.
        video_obj= videoinput('qimaging');
        video_src = getselectedsource(video_obj); %Create video source
    %   INITIAL Exposure
        video_src.Exposure= 0.15;
    %   Cooling ON
        video_src.Cooling = 'on';
        disp('CAMERA OPEN');
    catch
        msg = ['Error while opening camera'];
        h = errordlg(msg);
        imaqreset;
    end
end