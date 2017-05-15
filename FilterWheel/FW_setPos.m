function FW_setPos( FWSerial, pos )
%%  FW_SETPOS Move the filter wheel to a specific position
%   Pos must be an integer between 1 and 6

    if (pos<1) || (pos>6) || mod(pos,1)
        myMsg= ['Filter wheel position must be an integer between 1 and 6 (input was ' num2str(pos) ' and will be ignored)'];
    else
        myMsg= ['SET FW POSITION ' num2str(pos)];
        command = ['pos=' num2str(pos)];
        fprintf(FWSerial, command);
        fgets(FWSerial); % ECHO
    end
    disp(myMsg);
end

