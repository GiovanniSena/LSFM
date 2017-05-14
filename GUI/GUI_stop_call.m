function  GUI_stop_call( source, ~, mainFig )
%%  GUI_STOP_CALL Instructs the GUI to stop the automated scan
%   Sets the isStopping flag to 1.
%   The isStopping flag is read in the start_call function. If it is found
%   to be 1 the function will terminate the current loop iteration and
%   exit.

    setappdata(mainFig, 'isStopping', 1);
    set(source, 'string', '<html>STOP<br>WAIT...');
    myMsg= 'STOPPING SIGNAL RECEIVED; PLEASE WAIT...';
    disp(myMsg);
end

