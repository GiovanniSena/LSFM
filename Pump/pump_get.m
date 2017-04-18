function pump_get( myPump, pump )
%% PUMP_SET
%  Get speed of pump. If pump is 0 get speed for both.
    switch pump
        case 0
            command = 'getSp 1';
            %fprintf(myPump, command);
            pause(1);
            command = 'getSp 1' ;
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
        %pause(1);
        %nBytes = myPump.BytesAvailable
        %fscanf(myPump, '%s', nBytes);
        fscanf(myPump);
        disp(command);
    

end

