function [frame] = camera_snapshot_avg( video_obj, samples )
%%  Take N pictures and return the average image
%   This function instructs the camera to take a N pictures (N= samples) on
%   the current settings (exposure, gain, etc). The function then averages
%   the pictures to create a single frame. This is useful to reduce dark
%   noise on the pixels.
%   The frame is returned as output of the function in a matrix of grayscale values (dimensions depend on the set resolution).

    [res]= get(video_obj, 'VideoResolution');
    stack= zeros(res(2), res(1), samples);
    for i= 1:samples 
        oneframe= getsnapshot(video_obj);
        stack(:, :, i)= oneframe;
    end
    frame= uint16(mean(stack, 3));
end
