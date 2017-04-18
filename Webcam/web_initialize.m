function [ cam ] = web_initialize( varargin )
 %% WEB_INITIALIZE Connects to webcam
 %  Returns handle to the webcam.

 % List webcams and picks the first one
    if(numel(webcamlist))
        try
            cam = webcam(1);
            disp('WEBCAM OPEN');
            cam.Resolution= '1280x720';
        catch
            warning('Webcam already in use.');
            delete(timerfind); % In case the cam is stuck in a timer object.
        end
    else
        errorstring = 'No webcam found.';
        h = errordlg(errorstring) 
    end

end

