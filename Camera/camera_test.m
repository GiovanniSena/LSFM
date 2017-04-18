%http://uk.mathworks.com/help/imaq/previewing-data.html

%CONTANTS
expTime     = 0.5; 
frameDelay  = 1; %Wait 5 frames before starting logging (warm up camera)
framesPerTrigger = 1; %Acquire 5 frames at every trigger
frameGrabInt = 2; %Skip N frames between acquisitions

camera_info= imaqhwinfo('qimaging'); %Retrieve camera info

video_obj= videoinput('qimaging'); %Create video input object
set(video_obj, 'ReturnedColorspace', 'grayscale');

video_src = getselectedsource(video_obj); %Create video source


isrunning(video_obj)
if (isrunning(video_obj)==0)
    
    triggerconfig(video_obj, 'Manual')
    video_src.Exposure = expTime;
    video_obj.TriggerFrameDelay = frameDelay; 
    video_obj.FramesPerTrigger  = framesPerTrigger; 
    video_obj.FrameGrabInterval = frameGrabInt; 
    set(video_obj, 'ReturnedColorspace', 'grayscale');
    start(video_obj); %Starts the object, thus reserving it for Matlab
    
    %isrunning(video_obj); %%video object is in running state but does not start logging data until a trigger executes
    %islogging(video_obj);
    %trigger(video_obj);
    
    i= 0;
%     while (i < 20)
%         disp('Frame');
%         disp(video_obj.FramesAcquired);
%         pause(0.5)
%         i = i+1;
%     end
   prevImg= preview(video_obj); %Can be used even if the camera is not running or logging
   %prevImg= preview(video_obj, previewImage);
   
else
   disp('Video already running');
   stop(video_obj);
end
%singleFrame = getsnapshot(video_obj); %Better to have the preview running


% numberOfImageFiles= 3;
% singleFrame = getsnapshot(video_obj);
% [rows, cols ] = size(singleFrame);
% imageVec = zeros(rows, cols, numberOfImageFiles, 'like', singleFrame); %Vector containing the snapshots
% 
% for i= 1:numberOfImageFiles
%     singleFrame = getsnapshot(video_obj);
%     imageVec(:,:,i)= singleFrame;
%     pause(expTime+0.5);
%     disp(i);
% end
%imshow(imageVec(:,:,2), [0,4096] );



%delete(video_obj);
%clear video_obj;
%clear video_src;

%imaqreset Reset all cameras (useful if resource is locked)