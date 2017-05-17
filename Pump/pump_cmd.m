function [reply] = pump_cmd( myPump, command )
%%  PUMP_CMD Parses the command sent to the Arduino Pump
%   This template function can be used to parse the commands sent to the
%   pump. In the current code it has been split into several dedicated
%   functions.

    reply = '';
    fprintf(myPump, command);
    switch command
        case 'start'
            
        case 'start1'
            
        case 'start2'
            
        case 'stop'  
            
        case 'stop1'
            
        case 'stop2'
            
        case '+Sp1'
            
        case '-Sp1'
            
        case '+Sp2'
            
        case '-Sp2'
        
        case 'temp'
            %reply = fscanf(myPump, '%s', 21);
            reply = fscanf(myPump);
        otherwise
            %reply = fscanf(myPump, '%s', 10);
            reply = fscanf(myPump);
    end
end

