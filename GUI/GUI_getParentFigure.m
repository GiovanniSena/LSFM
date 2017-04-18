function fig = GUI_getParentFigure( fig )
 %% GUI_GETPARENTFIGURE Summary of this function goes here
 %   Detailed explanation goes here

    % if the object is a figure or figure descendent, return the
    % figure. Otherwise return [].
    while ~isempty(fig) & ~strcmp('figure', get(fig,'type'))
      fig = get(fig,'parent');
    end

end

