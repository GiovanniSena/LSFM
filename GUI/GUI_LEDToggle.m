function [ returnState ] = GUI_LEDToggle( state )
%GUI_LEDTOGGLE Summary of this function goes here
%   Detailed explanation goes here
   

    % Retrieve handles to Labjack object.
    ljudObj = getappdata(gcf, 'ledobj');
    ljhandle = getappdata(gcf, 'ledhandl');
    LedInd = getappdata(gcf, 'LedInd');
    port=4;
    returnState1 = LED_switch(ljudObj, ljhandle, port, state);
    port=5;
    returnState2 = LED_switch(ljudObj, ljhandle, port, state);
    
    returnState= returnState1 && returnState2;
    
    if(returnState) % Update indicator on mainFig
        set(LedInd, 'string', '<html>LED<br>ON');
        set(LedInd, 'backgroundcolor', 'green');
    else
        set(LedInd, 'string', '<html>LED<br>OFF');
        set(LedInd, 'backgroundcolor', 'default');
    end
    
end

