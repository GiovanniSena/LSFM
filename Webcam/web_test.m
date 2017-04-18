function web_test( ~ )
%WEB_TEST Summary of this function goes here
%   Detailed explanation goes here
    cam = web_initialize;
    preview(cam);
    properties(cam);
    cam.Resolution= '1280x720';
    disp('EXP');
    cam.Exposure = -5; %-10, -3
    %cam.Hue;
    %cam.AvailableResolutions;
    %cam.BacklightCompensation
    %cam.Brightness = 32; %-64, 64
    %cam.Tilt = 50; %-50 50
    %cam.Pan = -50; %-50 50;
    %cam.Zoom
%     for i= 1:4
%         pause(1);
%         cam.Pan = -10*i;
%         cam.BacklightCompensation = 0 +  i;
%     end
    closePreview(cam);
    web_close(cam);

end

