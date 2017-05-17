function [  ] = HW_shutterToggle( actxHandle, state)
%%  Sets che shutter to open/close
%   Variable state can either be 1 or 0, indicating that we want to OPEN or
%   CLOSE the shutter.
   
    if (state == 1)
        display('Shutter is now OPEN');
        actxHandle.SC_Enable(0);
    else
        display('Shutter is now CLOSED');
        actxHandle.SC_Disable(0);
    end
end

