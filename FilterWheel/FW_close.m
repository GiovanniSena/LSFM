function FW_close( FWSerial )
%%  FW_CLOSE Close serial communication with filter wheel
%   Use this to ensure the port is closed correctly.  

    try
        fclose(FWSerial);
        disp('FILTER WHEEL CLOSE');
        delete(FWSerial);
        clear FWSerial
    catch
        disp('Error closing serial communication with filter wheel.');
    end
end

