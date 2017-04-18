function HW_initialize ( source )
% Wait for the motors 
%   
    motorHandles = getappdata(source, 'actxHnd');
    motorSN = getappdata(source, 'HWSN');
    for i= 1:numel(motorHandles)
        motorHandles(i).StartCtrl; % Start Control
        set(motorHandles(i),'HWSerialNum', motorSN(i)); %Set serial numer in control
        %motorHandles(i).registerevent({'HomeComplete', 'HomeCompleteHandler'});
        
        motorHandles(i).registerevent({'HomeComplete', @HomeCompleteHandler});
        
        %motorHandles(i).registerevent({'HomeComplete', @(src,event) HomeCompleteHandler(src, event, motorHandles)});  
    end

end