function r = HW_isHoming(statusReg)
%%  HW_ISHOMING Check if the motor is currently homing.
%   Read StatusBits returned by GetStatusBits_Bits method and determine if
%   the motor shaft is moving to home; Return 1 if moving, return 0 if stationary.
%   Bit 10 of the status register indicates that the motor is still homing.
    
    r = bitget(int32(statusReg) , 10);
    
end
