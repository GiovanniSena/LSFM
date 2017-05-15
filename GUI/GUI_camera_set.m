function GUI_camera_set( source, ~ )
%%  GUI_CAMERA_SET Set main parameters of the camera
%   Allows the user to modify the main parameters (gain, exposure) of the
%   camera. Further parameters can be added by simply adding more cases in
%   the switch structure.
    
    value= get(source, 'value');
    tag= get(source, 'tag');
    vidobj = getappdata(gcf, 'vidobj'); 
    videosrc = getappdata(gcf, 'videosrc');
    
    switch tag
        case 'exposure'
            camera_set(vidobj, videosrc, 'Exposure', value);
            brightLabel = getappdata(gcf, 'brightLabel');
            newlabel = ['EXPOSURE ' num2str(value*1000,  '%0.2f') ' (ms)'];
            set(brightLabel, 'string', newlabel);
        case 'gain'
            value = round(value, 2);
            camera_set(vidobj, videosrc, 'NormalizedGain', value);
            gainLabel = getappdata(gcf, 'gainLabel');
            newlabel = ['GAIN ' num2str(value,  '%2.1f')];
            set(gainLabel, 'string', newlabel);
    end
end

