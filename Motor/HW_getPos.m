function [currentPos] = HW_getPos( actxHandle )
%HW_GETPOS Summary of this function goes here
%   Detailed explanation goes here

    currentPos= actxHandle.GetPosition_Position(0);
    
end

