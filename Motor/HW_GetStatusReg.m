function [ statusReg ] = HW_GetStatusReg( actxHnd )
 %% HW_GETSTATUSREG Return status register
 %   If I take (abs(staturReg) Matlab performs complement-2 so the bits are
 %   not correct.

    statusReg = int32(actxHnd.GetStatusBits_Bits(0));
    
end

