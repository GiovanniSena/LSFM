function TAB4_GUI(tab)
%%  Define content of tab #4
%   Contains axes for plots of root growth and temperatur monitor probes
    
%   TEMPERATURE AXES
    tempHaxes = axes('Parent', tab, ...
            'Units', 'normalized', ...
            'Position', [0.1 0.74 0.8 0.25]);
    setappdata(gcf, 'tempHaxes', tempHaxes);
    
%   ROOT TRACKING
    trackLocX= 0.1; 
    trackLocY= 0.41;
    trackLocW= 0.8;
    trackLocH= 0.23;
    XZhaxes = axes('Parent', tab, ...
        'Units', 'normalized', ...
        'Position', [trackLocX trackLocY trackLocW trackLocH]);
    xlabel(XZhaxes, 'Time [h]') ;
    ylabel(XZhaxes, 'Position [mm]') ;
    setappdata(gcf, 'XZhaxes', XZhaxes);
        
    YZhaxes = axes('Parent', tab, ...
        'Units', 'normalized', ...
        'Position', [trackLocX trackLocY-trackLocH-0.10 trackLocW trackLocH]);
    xlabel(YZhaxes, 'Time [h]') ;
    ylabel(YZhaxes, 'Mean intensity') ;
    setappdata(gcf, 'YZhaxes', YZhaxes);
end