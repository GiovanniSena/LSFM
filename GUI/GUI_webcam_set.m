function GUI_webcam_set( source, ~ )
 %% GUI_CAMERA_SET Summary of this function goes here
 %   Detailed explanation goes here
    
    value= get(source, 'value');
    tag= get(source, 'tag');
    webcam = getappdata(gcf, 'webcam'); 
    
    switch tag
        case 'web_LR'
            web_set(webcam, 'Pan', value);
        case 'web_UD'
            web_set(webcam, 'Tilt', value);
        case 'web_BRG'
            web_set(webcam, 'Brightness', value);
        case 'web_EXP'
            web_set(webcam, 'Exposure', value);
    end
end

