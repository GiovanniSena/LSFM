function r = HW_isHoming(statusReg)
 % Read StatusBits returned by GetStatusBits_Bits method and determine if
 % the motor shaft is moving; Return 1 if moving, return 0 if stationary
    
    r = bitget(int32(statusReg) , 10);
    
end
