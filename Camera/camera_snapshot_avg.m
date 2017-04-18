function [frame] = camera_snapshot_avg( video_obj, samples )
  %Take a picture and return the image
  %
    [res]= get(video_obj, 'VideoResolution');
    stack= zeros(res(2), res(1), samples);
    for i= 1:samples 
        oneframe= getsnapshot(video_obj);
        stack(:, :, i)= oneframe;
    end
    frame= uint16(mean(stack, 3));
    %pause(0.5);
end
