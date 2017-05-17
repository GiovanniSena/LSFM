function [ statusReg ] = HW_GetStatusReg( actxHnd )
%%  HW_GETSTATUSREG Return status register
%   Reads the content of the status register for one of the ActiveX
%   controllers for the Thorlabs motors.
%   Returns the content.

    statusReg = int32(actxHnd.GetStatusBits_Bits(0));
end

