function tempHW_close( myTemp )
%%  TEMPHW_CLOSE Close serial connection with Arduino temperature controller.
%   Close the connection with the temperature monitor Arduino in a clean
%   way so that the resources can be reused.

    try
        fprintf(myTemp, 'peltOFF');
        fclose(myTemp);
        delete(myTemp);
        disp('TEMP_HW CLOSE');
    catch
        disp('Error closing serial communication with TempArduino.');
    end
end

