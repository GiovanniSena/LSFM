function GUI_clickMove(source, ~, ~)
%%  GUI_clickMove: executed when one of the manual move buttons is pressed.
%   This is the main function in charge of correctly moving the motors when
%   the user presses one of the movement buttons.
%   Based on the combination of keys pressed, the motors can move in steps
%   of different amplitude. The values of the steps are defined in the
%   configuration file.
    
    
%   RETRIEVE THE NAME OF THE PARENT FIGURE FOR THE BUTTON
    mainFig= GUI_getParentFigure(source);
    confData= getappdata(mainFig, 'confPar');
    DEBUG= confData.application.debug;
    
%   DEFINE STEP SIZES IN MM (retrieve from myConfig.ini)
    stepSize = 0;
    smallStep= str2num(confData.application.smallstep)
    mediumStep= str2num(confData.application.mediumstep)
    largeStep= str2num(confData.application.largestep)
    
    if (DEBUG)
        disp('MANUAL MOVE CLICKED');
    end
    
    defColor= get(source, 'BackgroundColor'); %
    set(source, 'BackgroundColor', 0.9*defColor); % Button is disabled, so we change color manually
    
%   normal (left click), open (double click), extend (shift + left click) or alt (right click or ctrl + left click)
    clickType= get(mainFig,'SelectionType');
    
%   Determine amplitude of step, based on click type
    switch clickType
        case 'normal'
            if (DEBUG) disp('MOUSELEFT'); end
            stepSize = mediumStep;
        case 'open'
            if (DEBUG) disp('DOUBLE'); end
            stepSize = mediumStep;
        case 'extend'
            if (DEBUG) disp('SHIFT MOUSELEFT'); end
            stepSize = largeStep;
        case 'alt'
            if (DEBUG) disp('(CTRL + MOUSELEFT) or MOUSERIGHT'); end
            stepSize = smallStep;
        otherwise
            disp('do not know');
    end
    
%   Check which button was pressed and determine what motor to use.
%   get(source)
    motorHandles = getappdata(mainFig, 'actxHnd');
    buttonPressed = get(source, 'Tag');
    lockXCheck= getappdata(mainFig, 'lockXCheck');
    lockYCheck= getappdata(mainFig, 'lockYCheck');
    
    switch buttonPressed
        case 'Sy-'
            stepSize= stepSize*(-1);
            motor= motorHandles(2);
        case 'Sy+'
            motor= motorHandles(2);
        case 'Sx-'
            stepSize= stepSize*(-1);
            motor= motorHandles(1);
        case 'Sx+'
            motor= motorHandles(1);
        case 'Sz+'
            stepSize= stepSize*(-1);
            motor= motorHandles(3);
        case 'Sz-'
            motor= motorHandles(3);
        case 'C-'
            motor= motorHandles(4);
        case 'C+'
            stepSize= stepSize*(-1);
            motor= motorHandles(4);
        case 'F+'
            motor= motorHandles(5);
        case 'F-'
            stepSize= stepSize*(-1);
            motor= motorHandles(5);
        otherwise
            motor= 0;
    end
    
    pause(0.1);
    set(source, 'BackgroundColor', defColor); % Return button to default color.
    if (motor ~= 0)
    % Check if the "lock" flags are active
        if ((lockXCheck.Value==1) && (motor==motorHandles(1))) % Move Sx, follow with Cx
            HW_moveRelative(motor, stepSize);
            HW_moveRelative(motorHandles(4), -stepSize); 
        elseif ((lockXCheck.Value==1) && (motor==motorHandles(4))) % Move Cx, follow with Sx
            HW_moveRelative(motor, stepSize);
            HW_moveRelative(motorHandles(1), -stepSize); 
        elseif ((lockYCheck.Value==1) && (motor==motorHandles(2))) % Move Sy, follow with F
            HW_moveRelative(motor, stepSize);
            HW_moveRelative(motorHandles(5), -stepSize); 
        elseif ((lockYCheck.Value==1) && (motor==motorHandles(5))) % Move F, follow with Sy
            HW_moveRelative(motor, stepSize);
            HW_moveRelative(motorHandles(2), -stepSize);
        else
            HW_moveRelative(motor, stepSize); % Just move motor
        end
    end
end