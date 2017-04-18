function [ cam ] = web_close( cam )
 %% WEB_INITIALIZE Connects to webcam
 
    
    try
        clear('cam')  
        disp('WEBCAM CLOSE');
    catch
        warning('Could not close the webcam.');
    end
    
end

