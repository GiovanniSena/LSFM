function r = HW_isMoving(statusReg)
%%  HW_ISMOVING Check if the motor is currently moving.
%   Read StatusBits returned by GetStatusBits_Bits method and determine if
%   the motor shaft is moving in either direction; Return 1 if moving, return 0 if stationary.
%   If bits 5 or 6 of the status register are set the motor is moving in
%   the corresponding direction. Consult Thorlabs manual for further
%   details.
    
    r = bitget(int32(statusReg) , 5)|| bitget(int32(statusReg) , 6);
    
end
