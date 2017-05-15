function [ output_args ] = GUI_FWRadio( source, ~, pos )
%%  GUI_FWRADIO Executes when the Filter Wheel buttons are pressed
%   Calls the FW_set code.
    
    FWSerial= getappdata(gcf, 'FWSerial');
    FW_setPos(FWSerial, pos);
end

