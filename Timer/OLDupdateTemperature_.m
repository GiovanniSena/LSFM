function OLDupdateTemperature_( obj, event)
%function updateTemperature( obj, ~, tempTs, tempHaxes )
%UPDATETEMPERATURE Summary of this function goes here
%   Detailed explanation goes here
    
    
    tempHaxes= getappdata(gcf, 'tempHaxes');
    myPump= getappdata(gcf, 'myPump');

    c= now;
    %newTemp= 26+ rand(1)*(32-26);
    newTemp= pump_getT(myPump);
    
    tempTs = obj.UserData;
    
    disp(['nreTemp is ' newTemp]);
    
    if (newTemp ~= -300)
        obj.UserData = tempTs.addsample('Time', c , 'Data', newTemp);
        disp('ADDED');
    end
    
    plot(obj.UserData,  'Parent', tempHaxes);
    datetick(tempHaxes,'x', 'mm-dd HH:MM');
    
    
end


