function GUI_editPreview(obj, event, himage, varargin)
%GUI_EDITPREVIEW Edit the preview image from camera
%   For now just rotate it.
% NOTE: Preview data is uint8 (0-255).
    
    mainFig = getappdata(himage,'HandleToMainFig');
    searchFlag= getappdata(mainFig, 'isSearching'); 
    %searchFlag= 1;
% ROTATE IMAGE
    rotImg= event.Data;
    %rotImg= flipud(rotImg);
    %rotImg= fliplr(rotImg);
    rotImg= rot90(rotImg, -1);
    %rotImg = rot90(event.Data, -1);
    
% SCALE IMAGE IN PREVIEW
    scalerow= 520; %1040/2
    scalecol= 696; %1392/2
    rotImg = imresize(rotImg, [scalerow, scalecol] );
    
% %%%% SEARCH FOR ROOT
    if searchFlag
        oldMax= getappdata(mainFig, 'maxSearch');
        [sortValues, sortIndex]= sort( rotImg(:), 'descend');
        maxAvg= mean(sortValues(1:10));
        wholeAvg= mean(sortValues(:));
        if (wholeAvg > oldMax)
            confData= getappdata(gcf, 'confPar');
            logdir= confData.application.logdir;
            fprintf('ROOT SEARCH NEW MAX= %f, OLD= %f\n', wholeAvg, oldMax);
            setappdata(mainFig, 'maxSearch', wholeAvg);
            motorHandles = getappdata(mainFig, 'actxHnd');
            
            maxX=HW_getPos(motorHandles(1));
            maxY=HW_getPos(motorHandles(2));
            maxZ=HW_getPos(motorHandles(3));
            maxC=HW_getPos(motorHandles(4));
            maxF=HW_getPos(motorHandles(5));
            fprintf('ROOT SCAN INTENSITY MAX AT X= %f, Y= %f, Z= %f, C= %f, F= %f\n', maxX, maxY, maxZ, maxC, maxF);
            fileID = fopen([logdir 'rootsearch.txt'],'a');
            fprintf(fileID, 'ROOT SCAN AVG= %f AT X= %f, Y= %f, Z= %f, C= %f, F= %f\n', wholeAvg, maxX, maxY, maxZ, maxC, maxF);
            fclose(fileID);
        end
        fprintf('ROOT SEARCH maxAvg= %f, avg= %f\n', maxAvg, wholeAvg);
    end
% %%%%% END SEARCH FOR ROOT

% DISPLAY HISTO UNDER PREVIEW
    histoHaxes= getappdata(mainFig, 'histoHaxes');
   
    prevHisto = histogram('Parent', histoHaxes, rotImg, 'NumBins', 256, 'BinLimits',[0,255]);
    set(histoHaxes, 'YScale', 'log');   
    
% ADJUST CONTRAST (rescale image to that the brightest point is white)
    normPreviewCheck= getappdata(mainFig, 'prevNormCheck');
    if(normPreviewCheck.Value == 1)
        normPreviewValue= getappdata(mainFig, 'prevVal');
        lineXPos= str2num(normPreviewValue.String);
        histoPrevLine= line([lineXPos,lineXPos], histoHaxes.YLim, 'Parent', histoHaxes, 'color', 'red');
        %rotImg = uint8(rotImg*(double(255/max(rotImg(:))))); %CAN BE COMMENTED
        rotImg = uint8(rotImg*(double(255/lineXPos))); %CAN BE COMMENTED
    end
% DISPLAY IMAGE
    %set(himage, 'cdata', rotImg);
    
% SUPERIMPOSE TEXT TO IMAGE
    %tx = vision.TextInserter('Hello World!');
    %tx.FontSize = 40;
    %set(himage, 'cdata', step(tx, rotImg));
    
% TO ADD A ROI INDICATOR, UNCOMMENT THE FOLLOWING
    configData= getappdata(mainFig, 'confPar');
    %cameraX = str2double(configData.camera.camerax)/2; % /2 BECAUSE FIELD IS HALF SIZE IN PANEL
    %cameraY = str2double(configData.camera.cameray)/2;
    ROI_x= round(str2double(configData.camera.roi_x)*scalecol);
    ROI_y= round(str2double(configData.camera.roi_y)*scalerow);
    ROI_w= round(str2double(configData.camera.roi_w)*scalecol);
    ROI_h= round(str2double(configData.camera.roi_h)*scalerow);
    rectangle= int32([ROI_x ROI_y ROI_w ROI_h]);
    myColor = uint8([255 0 0]);
    shapeInserter = vision.ShapeInserter('Shape', 'Rectangles', 'BorderColor','Custom','CustomBorderColor', myColor, 'LineWidth', 1);
    rotImg = repmat(rotImg,[1,1,3]); % DO THIS TO CONVERT TO RBG SO THAT THE ROI IS COLORED

% ADD MARKERS TO INDICATE AUTOFOCUS REGION
    markerInserter = vision.MarkerInserter('Shape','Plus', 'BorderColor', 'Custom', 'CustomBorderColor', myColor);
    af_x=str2double(configData.camera.af_x)*scalecol;
    af_y=str2double(configData.camera.af_y)*scalerow;
    af_w=str2double(configData.camera.af_w)*scalecol;
    af_h=str2double(configData.camera.af_h)*scalerow;
    %Pts = int32([af_x af_y; af_x+af_w af_y; af_x af_y+af_h; af_x+af_w af_y+af_h; af_x+af_w/2 af_y+af_h/2]); % UNCOMMENT THIS LINE TO HAVE THE POINTS LOCATED AT AF_X, AF_Y...
    Pts= int32([scalecol/4 scalerow/4; 3*scalecol/4 3*scalerow/4; scalecol/2 scalerow/2; 3*scalecol/4 scalerow/4; scalecol/4 3*scalerow/4]); % USE THIS TO HAVE POINTS EQUALLY SPACED
    
% DISPLAY IMAGE
    %rotImg= step(shapeInserter, rotImg, rectangle); % UNCOMMENT TO INSERT THE RECTANGLE ROI
    finalImage= step(markerInserter, rotImg, Pts);
    %finalImage= step
    %set(himage, 'cdata', step(shapeInserter, rotImg, rectangle));
    set(himage, 'cdata', finalImage);
end

