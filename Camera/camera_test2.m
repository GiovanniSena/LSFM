function camera_test2()
%%  Debug tool to test the camera functionality.
%   Creates a minimal window with camera preview. Two buttons allow to
%   change the stream orientation and to take a snapshot.
%   This can be used to quickly debug a new camera and making sure all the
%   basic functios work correctly.

[video_obj, video_src ]= camera_initialize('qimaging');

%   Create a window
figure('Name', 'My Custom Preview Window'); 

%   Create the container
vidRes = video_obj.VideoResolution; 
nBands = video_obj.NumberOfBands;
myContainer = image( zeros(vidRes(1), vidRes(1), nBands) ); 

%   Buttons
btnClose = uicontrol('String', 'Close', 'Callback', {@myClose_fcn, video_obj, video_src, myContainer }); 

btnToggle = uicontrol('Style', 'togglebutton', 'String', 'UP',...
        'Position', [200 20 50 20],...
        'Callback', {@togglebutton1_Callback, myContainer}); 
    
btnSnap = uicontrol('String', 'SNAPSHOT',...
        'Position', [250 20 50 20],...
        'Callback', {@snapshot_fcn, video_obj}); 

%   Switch on the preview
myToggle= 1;
camera_previewToggle(video_obj, myContainer, myToggle);
imagedata= get(myContainer, 'cdata');
end

function mypreview_fcn(obj, event, himage)
%   Display image data.
    tx = vision.TextInserter('Hello World!');
%   Tx = insertText(vision, position,'Hello World!')
    tx.FontSize = 40;
    
    rotImg = rot90(event.Data, -1);
    set(himage, 'cdata', rotImg);
end

function togglebutton1_Callback(hObject,eventdata, myContainer)
button_state = get(hObject,'Value');
    if button_state == get(hObject,'Max')
        display('down');
        hObject.String = 'DOWN';
        setappdata(myContainer,'UpdatePreviewWindowFcn',@mypreview_fcn);
    elseif button_state == get(hObject,'Min')
        display('up');
        hObject.String = 'UP';
        setappdata(myContainer,'UpdatePreviewWindowFcn',[]);
    end
end

function myClose_fcn(~, ~, video_obj, video_src, myContainer)
%   Turns the preview off
    myToggle= 0;
    camera_previewToggle(video_obj, myContainer, myToggle);

%   Close all camera-related objects
    camera_close(video_obj, video_src);
    
%   Close window
    clear
    close(gcf)
end

function snapshot_fcn(~, ~, video_obj)
%   Take snapshot
    myPicture =  camera_snapshot(video_obj);
    
%   Save image to disk
    TIFF_write(myPicture, 'D:\Images\Test\newLens_150mm_grid.tif');
end