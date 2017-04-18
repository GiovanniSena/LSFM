function tempHW_close( myTemp )
%% TEMPHW_CLOSE Close serial connection with Arduino, returns serial object
%   

    try
        fprintf(myTemp, 'peltOFF');
        fclose(myTemp);
        delete(myTemp);
        disp('TEMP_HW CLOSE');
    catch
        disp('Error closing serial communication with TempArduino.');
    end
    %instrfind
    %instrfindall
end

