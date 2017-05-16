function [ dblValue ] = toggleLED(~, ~,  state)
%%  Switch on/off LEDs.
%   Return the status of the LEDs (1 = ON, 0 = OFF).

%   Make the UD .NET assembly visible in MATLAB
    ljasm = NET.addAssembly('LJUDDotNet');
    ljudObj = LabJack.LabJackUD.LJUD;

%   Open the first found LabJack U3.
    [ljerror, ljhandle] = ljudObj.OpenLabJack(LabJack.LabJackUD.DEVICE.U3, LabJack.LabJackUD.CONNECTION.USB, '0', true, 0);
    ljport=4;
    
%   Start by using the pin_configuration_reset IOType so that all pin assignments are in the factory default condition.
    ljudObj.ePut(ljhandle, LabJack.LabJackUD.IO.PIN_CONFIGURATION_RESET, 0, 0, 0);
    if (state == 1)
            %SWITCH LEDs ON
            %Set digital output FIO4 to output-high.
            ljudObj.AddRequest(ljhandle, LabJack.LabJackUD.IO.PUT_DIGITAL_BIT, ljport, 1, 0, 0);
            ljudObj.GoOne(ljhandle);
            display('Switching LEDs ON');
    else
            %SWITCH LEDs OFF
            %Set digital output FIO4 to output-low.
            ljudObj.AddRequest(ljhandle, LabJack.LabJackUD.IO.PUT_DIGITAL_BIT, ljport, 0, 0, 0);
            ljudObj.GoOne(ljhandle);
            display('Switching LEDs OFF');
    end
    
    ljudObj.AddRequest(ljhandle, LabJack.LabJackUD.IO.GET_DIGITAL_BIT_STATE, ljport, 0, 0, 0);
    ljudObj.GoOne(ljhandle);
    [~, ~, ~, dblValue, ~, dummyDbl] = ljudObj.GetFirstResult(ljhandle, 0, 0, 0, 0, 0);
    if (dblValue==1)
        display('LEDs ON');
    else
        display('LEDs OFF');
    end
end