function GUI_camera_set( source, ~ )
 %% GUI_CAMERA_SET Summary of this function goes here
 %   Detailed explanation goes here
    
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

