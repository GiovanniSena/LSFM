function  GUI_setVelocityParameters( mainFig, maxSpeedMotor, accMotor )
 %% GUI_SETVELOCITYPARAMETERS Summary of this function goes here
 %  Function to modify the velocity profile of the motors. All the checks
 %  are done here before calling the HW_setVelocityProfile.

  % Read application data
    motorHandles = getappdata(mainFig, 'actxHnd');
    confData= getappdata(mainFig, 'confPar');
    DEBUG= confData.application.debug;
   
    nMotors= numel(motorHandles)-1;
    [~,sizeMaxSpeed]= size(maxSpeedMotor);
    [~,sizeAcc]= size(accMotor);
    
    
  % SAFETY MAX PARAMETERS (too conservative?)
    maxSafeSpeed= 2.2;
    maxSafeAcc= 1.5;
    minSafeSpeed= 0.5;
    minSafeAcc= 0.5;
    
    if (sizeMaxSpeed ~= nMotors) || (sizeAcc ~= nMotors)
        fprintf('HW_setVelocityParameters requires two vectors with %d components. Passed vectors had %d and %d components.\nVelocity profile was not changed.\n', numel(motorHandles)-1, sizeMaxSpeed, sizeAcc );
    else
        % SET MAX VELOCITY AND ACCELERATION
        for iMotor= 1: (numel(motorHandles)-1)
            % Safety checks
            if accMotor(iMotor) > 1.5
                fprintf('Acceleration setting for motor %d too high (%f). Defaulted to %f.\n', iMotor, accMotor(iMotor), maxSafeAcc);
                accMotor(iMotor)= 1.5;
            end
            if accMotor(iMotor) < 0
                fprintf('Acceleration setting for motor %d too low (%f). Defaulted to %f.\n', iMotor, accMotor(iMotor), minSafeAcc);
                accMotor(iMotor)= 0.5;
            end
            if maxSpeedMotor(iMotor) > 2.2
                fprintf('Max speed setting for motor %d too high (%f). Defaulted to %f.\n', iMotor, maxSpeedMotor(iMotor), maxSafeSpeed);
                maxSpeedMotor(iMotor)= 2.2;
            end
            if maxSpeedMotor(iMotor) < 0
                fprintf('Max speed setting for motor %d too low (%f). Defaulted to %f.\n', iMotor, maxSpeedMotor(iMotor), minSafeSpeed);
                maxSpeedMotor(iMotor)= 0.5;
            end
        end    
            % Now we write the settings
            HW_setVelocityParameters(motorHandles, maxSpeedMotor, accMotor);
        
    end
end

