function pump_get( myPump, pump )
%%  PUMP_GET Queries the Arduino for the pump speed.
%   This function sends a query to the Arduino controller to retrieve the
%   current speed setting of the pump(s). "myPump" is the handle to the
%   serial connection to the Arduino, "pump" is the number of pump to
%   interrogate (if more than one is present).

    switch pump
        case 0
            command = 'getSp 1';
            %fprintf(myPump, command);
            pause(1);
            %command = 'getSp 2' ;
            %fprintf(myPump, command);
        case 1
            command = 'getSp 1';
            %fprintf(myPump, command);
            %pause(1);
            %fscanf(myPump, '%s');
        case 2
            command = 'getSp 2';
            %fprintf(myPump, command);
            %fscanf(myPump, '%s', 10);
    end
        fprintf(myPump, command);
        fscanf(myPump);
        disp(command);
end

