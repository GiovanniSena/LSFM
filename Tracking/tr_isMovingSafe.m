function [ safe ] = tr_isMovingSafe( mainFig, deltaY )
 %% TR_CHECKBEFOREMOVING Check if the next deltaY step will cause a collision with the objective
 %  Detailed explanation goes here
    
    motorHandles = getappdata(mainFig, 'actxHnd');
    Sy_pos= HW_getPos(motorHandles(2));
    F_pos= HW_getPos(motorHandles(5));
    
    configData= getappdata(mainFig, 'confPar');
    safedist = str2double(configData.motor.safedist_fy);
    
    currentDist= safedist - (Sy_pos + deltaY + F_pos);
    
    if (currentDist < 0.5)
        safe= 0;
    else
        safe=1;
    end
end

