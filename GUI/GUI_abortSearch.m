function  GUI_abortSearch( mainFig, source )
 %% GUI_ABORTSEARCH Interrupts the root search routine
 %  Sets the correct flag to indicate that the search is finished.

%   Set flag to stop search
    fprintf('Current search has been aborted by user.\n');
    setappdata(mainFig, 'isSearching', 0);
end

