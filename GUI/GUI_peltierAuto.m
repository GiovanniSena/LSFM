function [ output_args ] = GUI_peltierAuto( mainFig, newState )
 %% GUI_PELTAUTO Starts the timer that function as a thermostat for the Peltier.
 %  This function checks whether the thermostat timer is already running
 %  and then sets it to ON or OFF based on the user choice.

    if (isappdata(mainFig, 'peltierThermostat'))
        peltierThermostat= getappdata(mainFig, 'peltierThermostat');
        running= get(peltierThermostat, 'Running');

        currState = strcmp(running, 'on');
        if (currState)
            if (newState==1)
                % TIMER ALREADY RUNNING
                %disp('already running');
            else
                % TIMER RUNNING, WE WANT TO STOP IT
                stop(peltierThermostat);
            end
        else
            if (newState==1)
                % TIMER STOPPED, WE WANT TO START IT
                start(peltierThermostat);
            else
                % TIMER ALREADY STOPPED
                %disp('already stop');
            end
        end
    end
    
end

