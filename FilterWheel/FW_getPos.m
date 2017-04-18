function [ currentPos ] = FW_getPos( FWSerial )
 %% FW_GETPOS Returns the current position of the filter wheel
 %  Current position is an integer number between 1 and 6.
 
    disp('GET FW POSITION');
    command = 'pos?';
    fprintf(FWSerial, command);
    pause(1);
%     nBytes = FWSerial.BytesAvailable;
%     disp( [num2str(nBytes) ' bytes available']);
%     if (nBytes >0)
%         readback= fscanf(FWSerial, '%s', nBytes);
%         disp(['RAW ' readback]);
%         readback(strfind(readback, '=')) = [];
%         disp(['EDIT ' readback]);
%     else
%         myMsg= ['currentPos: error retrieving position'];
%         disp(myMsg);
%     end
    readback = fgets(FWSerial); % ECHO
    currentPos= fgets(FWSerial); %ACTUAL DATA
    %readback= fscanf(FWSerial); %
    %readback= fscanf(FWSerial);
    %currentPos= fscanf(FWSerial);
end

