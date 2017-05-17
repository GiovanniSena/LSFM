function pump_set( myPump, pump, speed )
%%  PUMP_SET Set pump speed via serial link.
%   Set speed of 'pump', where 'pump' can be either 1 or 2. If 'pump' is 0 set speed for both.

    speed = round(speed);
    if speed > 8000
        speed = 8000;
        text = 'Speed too high (max 8000). Speed set to max.';
        warning(text);
    elseif speed < 500
        speed = 500;
        text = 'Speed too low (min 500). Speed set to min.';
        warning(text);
    end
    switch pump
        case 0
            command = horzcat(['setSp 1 '], num2str(speed));
            fprintf(myPump, command);
            pause(1);
            command = horzcat(['setSp 2 '], num2str(speed));
            fprintf(myPump, command);
        case 1
            command = horzcat(['setSp '], num2str(pump), [' '], num2str(speed));
            fprintf(myPump, command);
        case 2
            command = horzcat(['setSp '], num2str(pump), [' '], num2str(speed));
            fprintf(myPump, command);
    end
        disp(command);
        pause(1);   
end

