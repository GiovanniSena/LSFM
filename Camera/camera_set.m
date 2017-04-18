function camera_set( video_obj, video_src, field, value )
  %Set parameters for camera
  %
%     propinfo(video_src)
%     disp('EXPOSURE')
%     propinfo(video_src, 'Exposure')
%     disp('READOUT')
%     propinfo(video_src, 'Readout')
%     disp('COOLING')
%     propinfo(video_src, 'Cooling')
%     disp('OFFSET')
%     propinfo(video_src, 'NormalizedGain')
%     get(video_obj, 'VideoResolution')
    %video_src.Exposure= value/1000;
    
    %SET REQUIRED FIELD
    video_src.(field)= value;
    myMsg= ['Camera ' field '= '  num2str(value) ];
    disp(myMsg);
    
    %EXTRA BITS
    %imaqhelp(video_obj, 'VideoResolution')
    %get(video_obj, 'VideoResolution')
    %video_src.get();
    %get(video_obj)
    %1.4000e-05 1.0737e+03 EXPOSURE
    
end
