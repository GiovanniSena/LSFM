function HW_initialize ( source )
% Initialize the motors
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
    disp('MOTORS OPEN');
    %events(motorHandles(6))
    %registerevent(motorHandles(6),@HomeCompleteHandler);
    %eventlisteners(motorHandles(6))
    
    %registerevent(motorHandles(1),@HomeCompleteHandler);
    %eventlisteners(motorHandles(1))
%     confData= getappdata(source, 'confPar');
%     collisioncheck=str2num(confData.application.collisioncheck)
%     if (collisioncheck)
%         disp('COLLISION CHECK ENABLED');
%         
%     end
end

