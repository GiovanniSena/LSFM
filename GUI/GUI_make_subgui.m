function [configGUI] = GUI_make_subgui(mainFigHandle, fileName)
%%  Programmatically create a subGUI
%   Creates a new figure with the parameters needed for a scan. The list of
%   parameters is retrieved from the [user] section of the config file. The
%   figure is adjusted to show all the parameters without needing to
%   rewrite the interface.

    White = [1  1  1];
    BGColor = .9*White;
        
 % Create a new window.  
    configGUI = figure('units','pixels',...
        'Menubar','none',...
        'NumberTitle', 'off',...
        'Name', 'Scan parameters',...
        'Color', BGColor,...
        'position',[350 210 400 600]);
        
    configData= getappdata(mainFigHandle, 'confPar');
 % Read the "User" section of struc
    parArray= fieldnames(configData.user);
    loopLength= length(parArray);
 % Parameters to determine location of indicators    
    stepY= -0.8/loopLength; %0.8 of panel length is dedicated to indicators
    fieldW= 0.12;
    fieldH= 0.05;

 %Place indicators on GUI
    for k=1 : loopLength 
        if (k <= round(loopLength/2) )
            fieldX= 0.22;
            labelX= 0.10;
            fieldY= 1+k*stepY;
        else
            fieldX= 0.72;
            labelX= 0.60;
            fieldY= 1+(k-round(loopLength/2))*stepY;
        end
        configDisplay(k)= uicontrol('style','edit',...
            'Units', 'normalized',...
            'position',[fieldX fieldY fieldW fieldH],...
            'string', configData.user.(parArray{k}) ,...
            'UserData',struct('defaultVal',configData.user.(parArray{k})),...
            'Callback', {@onEdit_call, parArray(k)},...
            'foregroundcolor','r');

        configLabel(k)= uicontrol('Style','text',...
            'Units', 'normalized',...
            'Position',[labelX-0.03 fieldY fieldW+0.03 fieldH],...
            'backgroundcolor', BGColor,...
            'String',parArray(k));
    end
        
 % Place two buttons to save and discard changes
    discardConfBtn= uicontrol(...
        'String','DISCARD',...
        'Units', 'normalized',...
        'Position', [0.62 0.01 0.15 0.07], ...
        'Callback',@discardConfig); %#ok<NASGU>

    saveConfBtn= uicontrol(...
        'String','ACCEPT',...
        'Units', 'normalized',...
        'Position', [0.22 0.01 0.15 0.07], ...
        'Callback',{@saveConfig, mainFigHandle, configDisplay, configLabel, fileName}); %#ok<NASGU>
          
end


function saveConfig(~, ~, mainFigHandle, confDispl, confLabl, fileName)
%%  Save the parameters from the config panel into a INI file
    disp('NOW SAVING');
    configData= getappdata(mainFigHandle, 'confPar');
    %fileName = '\\icnas4.cc.ic.ac.uk\pbaesso\myMATLAB\LaserDAQ\CFG\myConfig.ini';
    for k= 1: length(fieldnames(configData.user))
        label= char(get(confLabl(k), 'string'));
        value= get(confDispl(k), 'string');
        configData.user.(label)= value;
    end
    struct2ini(fileName,configData); %Save config to file

    setappdata(mainFigHandle,'isConfig', 1); 
    setappdata(mainFigHandle, 'confPar', configData); %Pass parameters back to mainFig
    close(gcbf);
end

function discardConfig(~, ~)
%%  Close config panel without saving
    disp('CONFIG DISCARDED');
    close(gcbf);
end

function onEdit_call(source, ~, handles)
%%  Check that input number are of numeric type.
%   source    handle to edit1 (see GCBO)
%   eventdata  reserved - to be defined in a future version of MATLAB
%   handles    structure with handles and user data (see GUIDATA)
    input = str2double(get(source,'string'));
    val=get(source,'UserData');


    if isnan(input)
      errorMsg = strcat('"',  handles, '" must be a numeric value.');
      errordlg(errorMsg,'Invalid Input','modal');
      val=get(source,'UserData'); 
      defValue= val.defaultVal;
      set(source, 'String', defValue);
      return
    else
      display(input);
      val.defaultVal = input;
      set(source,'UserData',val);
    end
end