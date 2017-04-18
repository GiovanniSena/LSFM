function [ peltierThermostat ] = timer_createPeltierThermostat( varargin)
 %% TIMER_CREATETEMP Create timer object to measure temperature
 %  This object is in charge of updating the temperature DISPLAY in the main
 %  GUI. The period used to read the probe is fixed to 8 seconds.
    
    peltierThermostat = timer;
    
    % RETRIEVE THE FEEDBACK PARAMETERS FROM THE CONFIGURATION FILE
    configData= getappdata(varargin{1}, 'confPar');
    posWindow= str2num(configData.temperature.poswindow);
    negWindow= str2num(configData.temperature.negwindow);
    negExtreme= str2num(configData.temperature.negextreme);
    initialStep= str2num(configData.temperature.initialstep);
    sensorID= str2num(configData.temperature.usesensor);
    feedbackPar= [posWindow, negWindow, negExtreme, initialStep, sensorID];
    
    
    % The sensors cannot update faster than once every 4 seconds. Let's keep
    % it safe and use 6 seconds periods as a minimum.
    
    peltierThermostat.StartDelay = 0;
    peltierThermostat.Period = 30;
    peltierThermostat.ExecutionMode = 'fixedRate';
    
    peltierThermostat.TimerFcn = {@updatePeltierThermostat, varargin{1}, feedbackPar};
    peltierThermostat.StartFcn = @initPeltierThermostat;
    peltierThermostat.StopFcn = {@stopPeltierThermostat, varargin{1}};
    setappdata(varargin{1}, 'peltierThermostat', peltierThermostat);

end

function updatePeltierThermostat( obj, event, mainFig, feedbackPar)
%function updateTemperature( obj, ~, tempTs, tempHaxes )
 %% UPDATEPELTIERTHERMOSTAT Check the cuvette temperature and start/stop the Peltier accordingly
 %  This function reads the temperature indicators and uses the value from
 %  the NTC to determine whether the Peltier needs to be switched on or
 %  off.
    
    
    TempIndIR= getappdata(mainFig, 'TempIndIR');
    TempIndNTC= getappdata(mainFig, 'TempIndNTC');
    targetTemp= getappdata(mainFig, 'targetTemp');
    myTemp= getappdata(mainFig, 'myTemp');
    
  % READ TARGET TEMPERATURE
    targetTemp= str2double(get(targetTemp, 'String')); 
    
  % READ IR_TEMP 
    newTempIR=str2double(get(TempIndIR, 'String'));
       
  % READ NTC_TEMP
    newTempNTC=str2double(get(TempIndNTC(1), 'String'));
    
    % USE THE PELTIER AS A HEATER
    posWindow= feedbackPar(1); % switch off if delta is above this
    negWindow= feedbackPar(2); % switch on if delta is below this
    negExtreme= feedbackPar(3); % worst case negative delta.
    initialStep= feedbackPar(4); % initial step when the peltier is off
    sensorID= feedbackPar(5); % what sensor shall we use for the feedback?
    
    switch sensorID
        case 0
            fprintf('Using IR sensor.\n');
            newTemperature= str2double(get(TempIndIR, 'String'));
        case 1
            fprintf('Using NTC sensor 1.\n');
            newTemperature=str2double(get(TempIndNTC(1), 'String'));
        case 2
            fprintf('Using NTC sensor 2.\n');
            newTemperature=str2double(get(TempIndNTC(2), 'String'));
        case 3
            fprintf('Using NTC sensor 3.\n');
            newTemperature=str2double(get(TempIndNTC(3), 'String'));
        otherwise
            fprintf('Unknowne sensor selected. Using default NTC sensor 1.\n');
            newTemperature=str2double(get(TempIndNTC(1), 'String'));
    end
    
    deltaT= newTemperature - targetTemp; % difference between cuvette temperature and target temperature
    fprintf('Target T= %2.1f, T(sensor)= %2.1f, DeltaT=%2.1f\n', targetTemp, newTemperature, deltaT);
    
    %fprintf('Feedback parameters. posWindow= %d, negWindow= %d, negExtreme= %d, initialStep= %d\n', posWindow, negWindow, negExtreme, initialStep);
    if deltaT >= posWindow
        GUI_peltierToggle(mainFig, 0, 0);
    end
    
    if (deltaT < negWindow)
        peltPower= ((deltaT-negWindow)*(100-initialStep)/(negExtreme-negWindow))+ initialStep;
        peltPower= round(peltPower);
        GUI_peltierToggle(mainFig, 1, peltPower);
    end
    
        
end

function initPeltierThermostat(obj, ~)
 %% Initialize the temperature timer
 %  
    
    
    disp('peltier Thermostat timer started');
    %obj.UserData= [];
    
end

function stopPeltierThermostat(obj, ~, mainFig)
 %% Executed when the temperature timer stops
    fprintf('peltier Thermostat timer stopped\n');
 
end

