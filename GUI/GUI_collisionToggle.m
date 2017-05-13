function GUI_collisionToggle( hObject, eventdata, mainFig, CollisionInd )
%%  GUI_TOGGLECOLLISION Enable/disable collision check for cuvette and objective
%   When the check is active, a dedicated function checks the distance between cuvette and objective
%   to ensure that there is not contact between them.
    
    button_state = get(hObject,'Value');
    if button_state == get(hObject,'Max')
        %display('ACTIVE');
        hObject.String = 'ON';
        CollisionInd.Enable= 'inactive';
        if (isappdata(mainFig, 'collisionTimer'))
            collisionTimer= getappdata(mainFig, 'collisionTimer');
        else
            collisionTimer= timer_createCollision( mainFig, CollisionInd );
            setappdata(mainFig, 'collisionTimer', collisionTimer);
        end
        start(collisionTimer);
        
    elseif button_state == get(hObject,'Min')
        %display('IDLE');
        hObject.String = 'OFF';
        CollisionInd.Enable= 'off';
        CollisionInd.String= '--';
        if (isappdata(mainFig, 'collisionTimer'))
            collisionTimer= getappdata(mainFig, 'collisionTimer');
            stop(collisionTimer);
        end
    end
end