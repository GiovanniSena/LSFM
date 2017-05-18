function timer_updateDistance( obj, event, mainFig, CollisionInd )
%%  TIMER_UPDATEDISTANCE Read position of F and Sy motors and calculate distance
%   This function is used in the timer_createCollision.
%   Monitor the distance between objective and cuvette and show it in the
%   main panel indicator.
%   The distance is calculated based on the motor coordinates and a
%   user-defined parameters. See LSFM documentation for details.

%   Retrieve current motor coordinates
    motorHandles = getappdata(mainFig, 'actxHnd');
    Sy_pos= HW_getPos(motorHandles(2));
    F_pos= HW_getPos(motorHandles(5));

%   Uncomment to have sound playing when collision is imminent. Rather annoying.    
    %WarnWave = [sin(1:.6:400), sin(1:.7:400), sin(1:.4:400)];
    %Audio = audioplayer(WarnWave, 22050);

%   Retrieve distance parameter
    configData= getappdata(mainFig, 'confPar');
    safedist = str2double(configData.motor.safedist_fy);

%   Calculate current distance cuvette-objective
    currentDist= safedist - (Sy_pos + F_pos);
    
%   Update the indicator appearance based on distance
    if (currentDist < 0)
        CollisionInd.String = 'CONTACT';
    else
        CollisionInd.String = num2str(currentDist);
    end
    
    if (currentDist < 0.5)
        CollisionInd.BackgroundColor= 'red';
        beep on;
        beep;
    elseif (currentDist >= 0.5) && (currentDist < 1.0)
        CollisionInd.BackgroundColor= 'yellow';
        beep on;
        %play(Audio);
        beep;
    else
        CollisionInd.BackgroundColor= 'white';
        beep off;
    end
end