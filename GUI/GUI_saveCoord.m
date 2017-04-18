function  GUI_saveCoord( sourceBtn )
%% GUI_SAVECOORD Store the current coordinates to file
%   
    motorHandles = getappdata(gcf, 'actxHnd');
    storedCoord = getappdata(gcf, 'storedCoord');
    coordFile= getappdata(gcf, 'coordFile');
    
    storedCoord.saved.sx= num2str(HW_getPos(motorHandles(1)), '%2.8f');
    pause(0.01);
    storedCoord.saved.sy= num2str(HW_getPos(motorHandles(2)), '%2.8f');
    pause(0.01);
    storedCoord.saved.sz= num2str(HW_getPos(motorHandles(3)), '%2.8f');
    pause(0.01);
    storedCoord.saved.c= num2str(HW_getPos(motorHandles(4)), '%2.8f');
    pause(0.01);
    storedCoord.saved.f= num2str(HW_getPos(motorHandles(5)), '%2.8f');
    pause(0.01);
    if(exist(coordFile)==2) 
        struct2ini(coordFile, storedCoord);
        myMsg= ['Coordinates saved to file: ' coordFile];
    else
        myMsg= ['File ' coordFile ' not found. Coordinates were not saved.'];
    end
    disp(myMsg);
end

