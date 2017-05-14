function [myStack]= GUI_takeSlices( sourceBtn, mainFig )
%%  GUI_TAKESLICES Take N pictures, moving Sy after each snapshot, and save them to file
%   Instructs the GUI that the user wants to record a stack of images.
%   Updates the indicators as needed and calls the hardware function to
%   take the snapshots.
    
    
%   READ FILE NAME
    fNameField =getappdata(gcf, 'fNameField');
    fileName= get(fNameField, 'string');
    if isempty(fileName)
        myError= ('Please specify a file name');
        errordlg(myError);
    else
        tr_takeSlices(mainFig, fileName);
    end
    
    disp('MANUAL SLICES DONE');
end

