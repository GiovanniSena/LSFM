function [MIPmean, MIPstDev]= GUI_displayMIP( mainFig, inputStack )
 %% GUI_DISPLAYMIP Display maximum intensity projection of the stack in the preview space
 %  The image is processed to extract the MIP in the Z direction (stack
 %  direction). Once rotated and resized, it is displayed in the panel on
 %  the main GUI.
 % v. May 10th, 2017, TF
 
    GUI_previewToggle( mainFig, 0 ); %turn preview off
    
    MIPz= max(inputStack, [], 3);
    MIPimage = MIPz;
    MIPimage= rot90(MIPimage, -1); % rotate the MIP because camera took it with root horizontal!
    
    scalerow= 520; %1040/2
    scalecol= 696; %1392/2
    MIPimage = imresize(MIPimage, [scalerow, scalecol] );

    previewImage = getappdata(mainFig, 'previewImage');  %gets the preview location
    set(previewImage, 'CData', MIPimage);
    MIPmean= mean(MIPimage(:));
    MIPstDev= std(double(MIPimage(:)));
end

