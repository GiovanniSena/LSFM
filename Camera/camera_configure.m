function camera_configure( video_obj, video_src, camSettings )
  %Set parameters for camera
  %
    camSettings.trgMode = 'Manual';
    camSettings.exposure = 1000; % in us. Range?
    camSettings.frameDelay= 1;
    camSettings.framePerTrg= 1;
    camSettings.frameGrabInt= 1;
    camSettings.colorSpace= 'grayscale';
    camSettings.cooling= 'on';
    
    triggerconfig(video_obj, camSettings.trgMode')
    video_src.Exposure = camSettings.exposure;
    video_obj.TriggerFrameDelay = camSettings.frameDelay; 
    video_obj.FramesPerTrigger  = camSettings.framePerTrg; 
    video_obj.FrameGrabInterval = camSettings.frameGrabInt; 
    set(video_obj, 'ReturnedColorspace', camSettings.colorSpace);
    
end
