function camera_test2()
[video_obj, video_src ]= camera_initialize('qimaging');

%Create a window
figure('Name', 'My Custom Preview Window'); 

%Create the container
vidRes = video_obj.VideoResolution; 
nBands = video_obj.NumberOfBands;
%myContainer = image( zeros(vidRes(2), vidRes(1), nBands) ); 
myContainer = image( zeros(vidRes(1), vidRes(1), nBands) ); 
%setappdata(myContainer,'UpdatePreviewWindowFcn',@mypreview_fcn); % <------------ FUNCTION CALLED WHEN UPDATE PREVIEW

% Buttons
btnClose = uicontrol('String', 'Close', 'Callback', {@myClose_fcn, video_obj, video_src, myContainer }); 

btnToggle = uicontrol('Style', 'togglebutton', 'String', 'UP',...
        'Position', [200 20 50 20],...
        'Callback', {@togglebutton1_Callback, myContainer}); 
    
btnSnap = uicontrol('String', 'SNAPSHOT',...
        'Position', [250 20 50 20],...
        'Callback', {@snapshot_fcn, video_obj}); 

%Switch on the preview
myToggle= 1;
camera_previewToggle(video_obj, myContainer, myToggle);

imagedata= get(myContainer, 'cdata');
% disp('SIZE');
% size(imagedata) %ans = 1040 1392
% disp('MIN MAX');
% disp(min(imagedata));
% disp(max(imagedata));


%Take snapshot
%myPicture =  camera_snapshot(video_obj);
%imshow(myPicture, [0,4096] );

%Save image to disk
%SaveImageToFile(myPicture, 'D:\Images\Test\saveTest.tiff');


end

function mypreview_fcn(obj, event, himage)
    % display image data.
    tx = vision.TextInserter('Hello World!');
    %tx = insertText(vision, position,'Hello World!')
    tx.FontSize = 40;
    
    rotImg = rot90(event.Data, -1);
    set(himage, 'cdata', rotImg);
    %set(himage, 'cdata', step(tx, event.Data));

end

function togglebutton1_Callback(hObject,eventdata, myContainer)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1
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

    %Turns the preview off
    myToggle= 0;
    camera_previewToggle(video_obj, myContainer, myToggle);

    %Close all camera-related objects
    camera_close(video_obj, video_src);
    
    %Close window
    clear
    close(gcf)
end

function snapshot_fcn(~, ~, video_obj)
 %Take snapshot
    myPicture =  camera_snapshot(video_obj);
    %imshow(myPicture, [0,4096] );
   
 %Save image to disk
    %SaveImageToFile(myPicture, 'D:\Images\Test\saveTest.tiff');
    TIFF_write(myPicture, 'D:\Images\Test\newLens_150mm_grid.tif');
    
    %myPicture =  camera_snapshot_avg(video_obj, 5);
    %TIFF_write(myPicture, 'D:\Images\Test\open_avg.tif');
end