function [ FWSerial ] = FW_initialize(sPort )
 %% FW_INITIALIZE Open communication with filter wheel
 %  
    %sPort= 'COM16';
    FWSerial = serial( sPort,'BaudRate',115200);  %COM will depend on USB port used.
    FWSerial.Terminator= {'CR', 'CR'}; % READ TERMINATOR, WRITE TERMINATOR
    FWSerial.databits= 8;
    FWSerial.Timeout= 3;
    try
        fopen(FWSerial);
        disp('FILTER WHEEL OPEN');
        pause(1); % Needed after opening to ensure the communication is active (?).
        
        command = '*idn?';
        fprintf(FWSerial, command);
        %pause(2);
        readback= fgets(FWSerial); % ECHO
        readback= fgets(FWSerial); %ACTUAL DATA
        
        FW_setPos(FWSerial, 1);
        %readback= fscanf(FWSerial) %#ok<NASGU>
        %readback= fscanf(FWSerial);
        %disp(readback); %THORLABS FW102C/FW212C Filter Wheel version 1.06

%         command = 'pcount=6'; % Define filter wheel with 6 positions (instead of 12)
%         fprintf(FWSerial, command);
%         readback= fscanf(FWSerial); % Read back the command just sent
% 
%         command = 'speed=1'; % Define speed (0= slow, 1= fast)
%         fprintf(FWSerial, command);
%         readback= fscanf(FWSerial); % Read back the command just sent
% 
%         command = 'sensors=0'; % Turn sensors off when idle (???)
%         fprintf(FWSerial, command);
%         readback= fscanf(FWSerial); % Read back the command just sent
    catch
       delete(instrfind('Port', sPort));
       disp('Error opening serial communication with filter wheel');
    end
    
    

    
    
%     pause(1);
%     
%     nBytes = FWSerial.BytesAvailable;
% 
%     disp([num2str(nBytes) ' bytes available']);
%     if (nBytes >0)
%         %readback= fscanf(FWSerial);
%         disp('HERE');
%         readback= fscanf(FWSerial, '%c', nBytes);
%         disp(readback);
%         readback= fscanf(FWSerial)
%     end
%     FWSerial.BytesAvailable
%     pause(2);
end

