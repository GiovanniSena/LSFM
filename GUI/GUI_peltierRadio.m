function  GUI_peltierRadio( source, ~, pos )
%%  GUI_PELTRADIO Function to react to the peltier radio button
%    This function can switch the Peltier on or off. It can also set the
%   code to automatically try to maintain a determined temperature.

    mainFig= GUI_getParentFigure(source);
    targetTemp= getappdata(mainFig, 'targetTemp');
    
    switch pos
        case 1
            set(targetTemp, 'enable', 'off');
            set(targetTemp, 'String', '----');
            GUI_peltierToggle(mainFig, 0, 0);
            GUI_peltierAuto(mainFig, 0);
        case 2
            set(targetTemp, 'enable', 'off');
            set(targetTemp, 'String', '----');
            GUI_peltierToggle(mainFig, 1, 99);
            GUI_peltierAuto(mainFig, 0);
        case 3
            set(targetTemp, 'enable', 'on');
            set(targetTemp, 'String', '23.0');
            fprintf('PELTIER SET TO AUTO\n');
            GUI_peltierAuto(mainFig, 1);
        otherwise
    end
            

end

