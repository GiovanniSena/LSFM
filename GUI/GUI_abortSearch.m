function  GUI_abortSearch( mainFig, source )
 %% GUI_ABORTSEARCH Summary of this function goes here
 %  Detailed explanation goes here
 
    % Set flag to stop search
    fprintf('Current search has been aborted by user.\n');
    setappdata(mainFig, 'isSearching', 0);
        


end

