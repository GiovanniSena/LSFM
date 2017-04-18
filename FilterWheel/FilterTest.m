function FilterTest(~ )
%FILTERTEST Summary of this function goes here
%   Detailed explanation goes here
    
%     filterFig = figure(...
%             'Units', 'pixels',...
%             'Toolbar', 'none',...
%             'Position',[ 100, 100, 800, 600 ],...
%             'NumberTitle', 'off',...
%             'MenuBar', 'none',...
%             'Resize', 'on',...
%             'Visible', 'on',... %SWITCH OFF WHEN READY TO DEPLOY
%             'DockControls', 'off');
%     


    disp('INIT DONE');
    mySerialFW = FW_initialize('COM16');
    
    
    
    for i= 1:3
        FW_setPos(mySerialFW, i);
        FW_getPos(mySerialFW)
        %pause(0.5);
    end
    FW_setPos(mySerialFW, 1);
    FW_close(mySerialFW);

end

