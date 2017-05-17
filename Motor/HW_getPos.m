function [currentPos] = HW_getPos( actxHandle )
%%  HW_GETPOS Returns the current position of the chosen motor
%   This function takes for input an ActiveX handle created in the GUI for
%   one of the Thorlabs motors, queries the motor position and returns the
%   position value (float).

    currentPos= actxHandle.GetPosition_Position(0);
end

