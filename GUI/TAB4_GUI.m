function TAB4_GUI(tab)    
    
% TEMPERATURE AXES
    tempHaxes = axes('Parent', tab, ...
            'Units', 'normalized', ...
            'Position', [0.1 0.74 0.8 0.25]);
%     set(tempHaxes, 'title','XZ');
        %xlabel(tempHaxes, 'Time');
        %title(tempHaxes, 'Temperature');
        %xlabel('X') ;
        %ylabel('T') ;
    setappdata(gcf, 'tempHaxes', tempHaxes);
    
 %% ROOT TRACKING
    trackLocX= 0.1; 
    trackLocY= 0.41;
    trackLocW= 0.8;
    trackLocH= 0.23;
    XZhaxes = axes('Parent', tab, ...
        'Units', 'normalized', ...
        'Position', [trackLocX trackLocY trackLocW trackLocH]);
    %plot(XZhaxes, 1:200, sin((1:200)./12));
    %title('XZ');
    xlabel(XZhaxes, 'Time [h]') ;
    ylabel(XZhaxes, 'Position [mm]') ;
    setappdata(gcf, 'XZhaxes', XZhaxes);
        
    YZhaxes = axes('Parent', tab, ...
        'Units', 'normalized', ...
        'Position', [trackLocX trackLocY-trackLocH-0.10 trackLocW trackLocH]);
    %plot(YZhaxes, 1:200, tan((1:200)./12));
    %title('YZ'); 
    xlabel(YZhaxes, 'Time [h]') ;
    % ylabel(YZhaxes, 'total path [mm]') ;  % for original with distance moved
    ylabel(YZhaxes, 'Mean intensity') ;
    setappdata(gcf, 'YZhaxes', YZhaxes);

    
    
end