function [reply] = pump_cmd( myPump, command )
%% PUMP_INITIALIZE Open serial connection with Arduino, returns serial object
%   
    reply = '';
    fprintf(myPump, command);
    %pause(0.5);
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
    
        %disp(reply);
    
    %instrfind
    %instrfindall
end

