function [frame] = camera_snapshot( video_obj )
%%  Take a picture and return the image
%   This function instructs the camera to take a single picture based on
%   the current settings (exposure, gain, etc). The frame is returned as
%   output of the function in a matrix of grayscale values (dimensions depend on the set resolution).

    frame = getsnapshot(video_obj);
end
