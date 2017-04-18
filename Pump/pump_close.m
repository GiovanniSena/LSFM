function pump_close( myPump )
%% PUMP_INITIALIZE Open serial connection with Arduino, returns serial object
%   

    try
        fclose(myPump);
        delete(myPump);
        disp('PUMP CLOSE');
    catch
        disp('Error closing serial communication with PumpArduino.');
    end
    %instrfind
    %instrfindall
end

