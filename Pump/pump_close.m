function pump_close( myPump )
%%  PUMP_CLOSE Close serial connection with pump.
%   Releases the serial port used to communicate with the Pump (Arduino).
%   Delete all objects connected with the pump.

    try
        fclose(myPump);
        delete(myPump);
        disp('PUMP CLOSE');
    catch
        disp('Error closing serial communication with PumpArduino.');
    end
end

