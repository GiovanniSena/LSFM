function timer_updateDistance( obj, event, mainFig, CollisionInd )
 %% READ position of F and Sy motors and calculate distance
 % Show distance in main panel indicator.
 
    motorHandles = getappdata(mainFig, 'actxHnd');
    Sy_pos= HW_getPos(motorHandles(2));
    F_pos= HW_getPos(motorHandles(5));
    
    %WarnWave = [sin(1:.6:400), sin(1:.7:400), sin(1:.4:400)];
    %Audio = audioplayer(WarnWave, 22050);

    configData= getappdata(mainFig, 'confPar');
    safedist = str2double(configData.motor.safedist_fy);
    
    currentDist= safedist - (Sy_pos + F_pos);
    
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