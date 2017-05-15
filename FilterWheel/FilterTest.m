function FilterTest(~ )
%%  FILTERTEST Test the communication with the filter wheel
%   This utility function offers tests the communication with the filter
%   wheel by opening a serial port, sending a few instructions to the wheel
%   then closing the communication.

%   Initialize communication
    disp('INIT DONE');
    mySerialFW = FW_initialize('COM16');

%   Test the wheel by moving it and reading its position
    for i= 1:3
        FW_setPos(mySerialFW, i);
        FW_getPos(mySerialFW)
    end
    FW_setPos(mySerialFW, 1);
%   Close the communication
    FW_close(mySerialFW);
end

