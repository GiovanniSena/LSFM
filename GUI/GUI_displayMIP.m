function [MIPmean, MIPstDev]= GUI_displayMIP( mainFig, inputStack )
 %% GUI_DISPLAYMIP Display maximum intensity projection of the stack in the preview space
 %  The image is processed to extract the MIP in the Z direction (stack
 %  direction). Once rotated and resized, it is displayed in the panel on
 %  the main GUI.
 
 % v. 161027

    MIPz= max(inputStack,[],3);
    MIPimage= squeeze(MIPz);
    MIPimage= rot90(MIPimage, -1); % rotate the MIP because camera took it with root horizontal!
    
    scalerow= 520; %1040/2
    scalecol= 696; %1392/2
    MIPimage = imadjust(MIPimage, [0;0.005], [0.0;1.0]);  % Normally the pixels would appear very dark, but this is because a 12-bit image (0>4096) is shown. This normalizes the pixels across this range.
    MIPimage = imresize(MIPimage, [scalerow, scalecol] );
    
    previewImage = getappdata(mainFig, 'previewImage');
    set(previewImage, 'CData', MIPimage);
    MIPmean= mean(MIPimage(:));
    MIPstDev= std(double(MIPimage(:)));
end

