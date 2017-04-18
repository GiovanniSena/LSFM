function pump_start( myPump, pump )
%% PUMP_START
%  Start pump. If pump is 0 start both.
    switch pump
        
        case 0
            command = 'start';
        case 1
            command = 'start1';
        case 2
            command = 'start2';
    end
        fprintf(myPump, command);
    

end

