function HW_setVelocityParameters( motorHandles, maxSpeedMotor, accMotor )
%%  HW_GETVELOCITYPARAMETERS 
%   Set the parameters for the max velocity and acceleration of the motors.
%   This values are used to determine the velocity profile
%   followed by the motor when performing a movement. The function returns
%   two vectors, with N components (where N is the number of motors in the
%   system).
%   Note: this function does not perform a sanity check on the values. The
%   user is required to ensure that maxSpeedMotor and accMotor are
%   compatible with the hardware in use.

    for iMotor= 1: (numel(motorHandles)-1)
    %   Now we write the settings
    %   (all the checks done before hand)
        fprintf('Setting motor %d profile to Vmax= %2.1f, Acc= %2.1f\n', iMotor, maxSpeedMotor(iMotor), accMotor(iMotor));
        motorHandles(iMotor).SetVelParams(0, 0, accMotor(iMotor), maxSpeedMotor(iMotor) );
    end
end

