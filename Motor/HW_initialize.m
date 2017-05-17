function HW_initialize ( source )
%%  HW_INITIALIZE Initialize the motors
%   This function reads the handles of the ActiveX controls in the GUI and
%   assigns to each of them the correct serial number for the corresponding
%   motor. It also assigns the callback function that is executed when the
%   motor movement is completed.
%   
    motorHandles = getappdata(source, 'actxHnd');
    motorSN = getappdata(source, 'HWSN');
    for i= 1:numel(motorHandles)
        motorHandles(i).StartCtrl; % Start Control
        set(motorHandles(i),'HWSerialNum', motorSN(i)); %Set serial numer in control
        motorHandles(i).registerevent({'HomeComplete', @HomeCompleteHandler});
    end
    disp('MOTORS OPEN');
end

