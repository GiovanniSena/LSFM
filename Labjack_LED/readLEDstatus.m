function [ dblValue ] = readLEDstatus( ~ )
%Read LED status from Labjack. Return 1 for ON, 0 for OFF.
%
    ljasm = NET.addAssembly('LJUDDotNet'); %Make the UD .NET assembly visible in MATLAB
    ljudObj = LabJack.LabJackUD.LJUD;

    %Open the first found LabJack U3.
    [ljerror, ljhandle] = ljudObj.OpenLabJack(LabJack.LabJackUD.DEVICE.U3, LabJack.LabJackUD.CONNECTION.USB, '0', true, 0);

    
    ljudObj.AddRequest(ljhandle, LabJack.LabJackUD.IO.GET_DIGITAL_BIT_STATE, 4, 0, 0, 0);
    ljudObj.GoOne(ljhandle);
    [~, ~, ~, dblValue, ~, dummyDbl] = ljudObj.GetFirstResult(ljhandle, 0, 0, 0, 0, 0);
    if (dblValue==1)
        display('LEDs ON');
    else
        display('LEDs OFF');
    end
    %methods(ljudObj)

end

