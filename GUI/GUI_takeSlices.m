function [myStack]= GUI_takeSlices( sourceBtn, mainFig )
 %% GUI_TAKESLICES Take N pictures, moving Sy after each snap, and save them to file
 %   
    
        
    confData= getappdata(mainFig, 'confPar');
    DEBUG= confData.application.debug;
    saveDir= confData.application.savedir;
    logDir= confData.application.logdir;
    
    
  % READ FILE NAME
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

