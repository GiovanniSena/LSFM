function  GUI_loadCoord( sourceBtn )
%% GUI_SAVECOORD Load coordinates from file and position the stages
%   
    motorHandles = getappdata(gcf, 'actxHnd');
    coordFile= getappdata(gcf, 'coordFile');
    
    %setappdata(mainFig, 'storedCoord', storedCoord);
    % TO DO: CHECK FOR COLLISIONS!
    if(exist(coordFile)==2)
        storedCoord = ini2struct(coordFile);
        HW_moveAbsolute(motorHandles(1), str2double(storedCoord.saved.sx));
        HW_moveAbsolute(motorHandles(2), str2double(storedCoord.saved.sy));
        HW_moveAbsolute(motorHandles(3), str2double(storedCoord.saved.sz));
        HW_moveAbsolute(motorHandles(4), str2double(storedCoord.saved.c));
        HW_moveAbsolute(motorHandles(5), str2double(storedCoord.saved.f));
        myMsg= ['Coordinates loaded from file: ' coordFile];
    else
        myMsg= ['File ' coordFile ' not found. Coordinates were not loaded.'];
    end
    disp(myMsg);
end

