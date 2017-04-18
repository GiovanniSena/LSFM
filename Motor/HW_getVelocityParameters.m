function [maxSpeedMotor, accMotor] = HW_getVelocityParameters( source )
 %% HW_GETVELOCITYPARAMETERS 
 %  Return the current setting for the max velocity of the motors and the
 %  acceleration. This values are used to determine the velocity profile
 %  followed by the motor when performing a movement. The function returns
 %  two vectors, with N components (where N is the number of motors in the
 %  system).

    motorHandles = getappdata(source, 'actxHnd');
    confData= getappdata(gcf, 'confPar');
    DEBUG= confData.application.debug;
    
    % INITIALIZE ARRAYS
    maxSpeedMotor= zeros(numel(motorHandles)-1, 1);
    accMotor= zeros(numel(motorHandles)-1, 1);
    
    % READ MAX VELOCITY AND ACCELERATION
    for iMotor= 1: (numel(motorHandles)-1)
        maxSpeedMotor(iMotor)= motorHandles(iMotor).GetVelParams_MaxVel(0);
        accMotor(iMotor)= motorHandles(iMotor).GetVelParams_Accn(0);
        %currentPos= actxHandle.GetPosition_Position(0);
    end
    disp(maxSpeedMotor);
    disp(accMotor);

end

