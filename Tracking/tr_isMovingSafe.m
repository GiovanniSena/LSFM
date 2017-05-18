function [ safe ] = tr_isMovingSafe( mainFig, deltaY )
%%  TR_ISMOVINGSAFE Check if the next deltaY step will cause a collision with the objective
%   Before moving the cuvette stage, verify that the required position will
%   not cause it to collide with the objective.
%   Returns 1 if the movement is legal, 0 if it would cause a collision (dist < 0.5 mm).
    
%   Retrieve motor handles
    motorHandles = getappdata(mainFig, 'actxHnd');
    Sy_pos= HW_getPos(motorHandles(2));
    F_pos= HW_getPos(motorHandles(5));

%   Retrieve distance parameter
    configData= getappdata(mainFig, 'confPar');
    safedist = str2double(configData.motor.safedist_fy);
    
%   Calculate distance after required movement
    currentDist= safedist - (Sy_pos + deltaY + F_pos);
    
    if (currentDist < 0.5)
        safe= 0;
    else
        safe=1;
    end
end

