function [ returnState ] = GUI_LEDToggle( state )
%%  GUI_LEDTOGGLE Toggles the LED indicator and executes the code to switch the cluster on/off
%   This function updates the GUI indicators with the correct status for
%   the LED cluster. It also calls the appropriate functions to actually
%   switch the cluster on/off.
   
%   Retrieve handles to Labjack object.
    ljudObj = getappdata(gcf, 'ledobj');
    ljhandle = getappdata(gcf, 'ledhandl');
    LedInd = getappdata(gcf, 'LedInd');
    port=4;
    returnState1 = LED_switch(ljudObj, ljhandle, port, state);
    port=5;
    returnState2 = LED_switch(ljudObj, ljhandle, port, state);
    
    returnState= returnState1 && returnState2;
    % Update indicator on mainFig
    if(returnState)
        set(LedInd, 'string', '<html>LED<br>ON');
        set(LedInd, 'backgroundcolor', 'green');
    else
        set(LedInd, 'string', '<html>LED<br>OFF');
        set(LedInd, 'backgroundcolor', 'default');
    end
end

