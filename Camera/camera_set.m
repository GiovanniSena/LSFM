function camera_set( video_obj, video_src, field, value )
%%  Use to modify camera settings after initialization
%   The value of "field" must be one that the camera supports (check the
%   camera manual for details). Some parameters are common to all camera
%   (for instance "Exposure").
%   The "value" specifies the assigned value for the parameters. The user
%   should make sure that the value typed is compatible with the camera
%   settings.
%   Examples of valid parameters:
%     propinfo(video_src, 'Exposure')
%     propinfo(video_src, 'Readout')
%     propinfo(video_src, 'Cooling')
%     propinfo(video_src, 'NormalizedGain')
%     get(video_obj, 'VideoResolution')
    
%   SET REQUIRED FIELD
    video_src.(field)= value;
    myMsg= ['Camera ' field '= '  num2str(value) ];
    disp(myMsg);
end
