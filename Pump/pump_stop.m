function pump_stop( myPump, pump )
%% PUMP_STOP
%  Stop pump. If pump is 0 stop both.
    switch pump
        
        case 0
            command = 'stop';
        case 1
            command = 'stop1';
        case 2
            command = 'stop2';
    end
        fprintf(myPump, command);
    

end

