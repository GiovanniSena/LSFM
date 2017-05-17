function [ statusBit ] = HW_GetStatusBit( actxHnd, i )
%%  HW_GETSTATUSBIT Return specific bit from status register
%   Returns the status of a specific bit from the statur register of one of
%   the Thorlabs motors. See Thorlabs documentation foe details.
%   actxHnd is the ActiveX handle for the motor initialized in the GUI.

    statusReg = actxHnd.GetStatusBits_Bits(0);
    statusBit = bitget(int32(statusReg), i);
end

