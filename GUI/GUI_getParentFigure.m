function fig = GUI_getParentFigure( fig )
%%  GUI_GETPARENTFIGURE Utility function to retrieve the handle of an object's parent figure
%   This function returns the parent figure of a subfigre. This is useful
%   to identify the handle to the main GUI.
%   If the object is a figure or figure descendent, return the
%   figure. Otherwise return [].

    while ~isempty(fig) & ~strcmp('figure', get(fig,'type'))
      fig = get(fig,'parent');
    end
end

