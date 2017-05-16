function [ dblValue ] = LED_switch(ljudObj, ljhandle, port, state)
%%  Switch LED clusters on/off LED. Return the status of the LEDs (1 = ON, 0 = OFF).
%   State is a number, not a char.
    
    confData= getappdata(gcf, 'confPar');
    DEBUG= confData.application.debug;
    if (state == 1)
            %SWITCH LEDs ON
            %Set digital output FIO4 to output-high.
            ljudObj.AddRequest(ljhandle, LabJack.LabJackUD.IO.PUT_DIGITAL_BIT, port, 1, 0, 0);
            ljudObj.GoOne(ljhandle);
            %if(DEBUG) display('Switching LEDs ON'); end
    else
            %SWITCH LEDs OFF
            %Set digital output FIO4 to output-low.
            ljudObj.AddRequest(ljhandle, LabJack.LabJackUD.IO.PUT_DIGITAL_BIT, port, 0, 0, 0);
            ljudObj.GoOne(ljhandle);
            %if(DEBUG) display('Switching LEDs OFF'); end
    end
    ljudObj.AddRequest(ljhandle, LabJack.LabJackUD.IO.GET_DIGITAL_BIT_STATE, port, 0, 0, 0);
    ljudObj.GoOne(ljhandle);
    [~, ~, ~, dblValue, ~, dummyDbl] = ljudObj.GetFirstResult(ljhandle, 0, 0, 0, 0, 0);
    if (dblValue==1)
        display('LEDs ON');
    else
        display('LEDs OFF');
    end
end