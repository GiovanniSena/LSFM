function [ dblValue ] = LED_readStatus( ljudObj, ljhandle, port )
%%  Read LED status from Labjack. Return 1 for ON, 0 for OFF.
%   Query the status of the pins that control the LED clusters and return
%   it (0= off, 1= on).

    ljudObj.AddRequest(ljhandle, LabJack.LabJackUD.IO.GET_DIGITAL_BIT_STATE, 4, 0, 0, 0);
    ljudObj.GoOne(ljhandle);
    [~, ~, ~, dblValue, ~, dummyDbl] = ljudObj.GetFirstResult(ljhandle, 0, 0, 0, 0, 0);
    if (dblValue==1)
        %display('LEDs ON');
    else
        %display('LEDs OFF');
    end
end

