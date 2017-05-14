function GUI_updatePlots( mainFig, myTimeseries1, myTimeseries2, myTimeseries3, myTimeseries4 )
%%  GUI_UPDATEPLOTS Updates the plots in the "plots" tab with data from timeseries.
%   The first 3 timeseries will be plotted together in the middle graph, the last
%   timeseries will be plotted on its own on the bottom graph.
 
    XZhaxes= getappdata(mainFig, 'XZhaxes'); % PLOT FOR XZ
    YZhaxes= getappdata(mainFig, 'YZhaxes'); % PLOT FOR YZ
    
    % Show time in specific units
    unit= 24; % Use 86400 for seconds, 1440 for minutes, 24 for hours
    
    temporaryX= myTimeseries1;
    temporaryX.Time= unit*(temporaryX.Time - temporaryX.Time(1)); 
    temporaryY= myTimeseries2;
    temporaryY.Time= unit*(temporaryY.Time - temporaryY.Time(1)); 
    temporaryZ= myTimeseries3;
    temporaryZ.Time= unit*(temporaryZ.Time - temporaryZ.Time(1)); 
    temporarydS= myTimeseries4;
    temporarydS.Time= unit*(temporarydS.Time - temporarydS.Time(1)); 
    
    plot(temporaryX,  'Parent', XZhaxes);
    hold(XZhaxes, 'on');
    plot(temporaryY,  'Parent', XZhaxes);
    hold(XZhaxes, 'on');
    plot(temporaryZ,  'Parent', XZhaxes);
    xlabel(XZhaxes, 'Time [h]') ;
    ylabel(XZhaxes, 'Position [mm]');
    legend(XZhaxes, 'X', 'Y', 'Z', 'Location', 'northwest', 'Orientation', 'horizontal');
    hold(XZhaxes, 'off');

    plot(temporarydS,  'Parent', YZhaxes);
    title(YZhaxes, '');
    xlabel(YZhaxes, 'Time [h]') ;
    ylabel(YZhaxes, 'Intensity') ;
end

