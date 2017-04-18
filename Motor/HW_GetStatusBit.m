function [ statusBit ] = HW_GetStatusBit( actxHnd, i )
%% HW_GETSTATUSBIT Return specific bit from status register
%   If I take (abs(staturReg) Matlab performs complement-2 so the bits are
%   not correct.

    statusReg = actxHnd.GetStatusBits_Bits(0);
    
    statusBit = bitget(int32(statusReg), i);
  
end

