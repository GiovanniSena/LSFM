function [ peltierThermostat ] = timer_createPeltierThermostat( varargin)
%%  TIMER_CREATETEMP Create timer object to control Peltier based on temperature reading
%   This timer is in charge of acting like a thermostat, monitoring the
%   reading of one of the temperature sensors and activating the Peltier if
%   the temperature falls below a user-defined threshold.
%   A detaild explanation of the feedback function is given tin the LSFM
%   user manual.

%   Create timer
    peltierThermostat = timer;
    
%   Retrieve feedback parameters from configuration file
    configData= getappdata(varargin{1}, 'confPar');
    posWindow= str2num(configData.temperature.poswindow);
    negWindow= str2num(configData.temperature.negwindow);
    negExtreme= str2num(configData.temperature.negextreme);
    initialStep= str2num(configData.temperature.initialstep);
    sensorID= str2num(configData.temperature.usesensor); % Define which temperature sensor to monitor
    feedbackPar= [posWindow, negWindow, negExtreme, initialStep, sensorID];
    
%   Define periodic execution parameters    
    peltierThermostat.StartDelay = 0;
    peltierThermostat.Period = 30;
    peltierThermostat.ExecutionMode = 'fixedRate';
    
%   Assign timer functions    
    peltierThermostat.TimerFcn = {@updatePeltierThermostat, varargin{1}, feedbackPar};
    peltierThermostat.StartFcn = @initPeltierThermostat;
    peltierThermostat.StopFcn = {@stopPeltierThermostat, varargin{1}};
    setappdata(varargin{1}, 'peltierThermostat', peltierThermostat);
end

function updatePeltierThermostat( obj, event, mainFig, feedbackPar)
%%  UPDATEPELTIERTHERMOSTAT Check the cuvette temperature and start/stop the Peltier accordingly
%   This function reads the temperature indicators and uses the value from
%   the temperature sensor to determine whether the Peltier needs to be switched on or
%   off. Note that the function does not use the reading from the sensors,
%   rather reads the current values of the temperature indicators, so we
%   can perform smoothing on the data put in the display and base the
%   thermostat on that data, rather than raw data from sensors.
    
%   Retrieve indicators handles
    TempIndIR= getappdata(mainFig, 'TempIndIR');
    TempIndNTC= getappdata(mainFig, 'TempIndNTC');
    targetTemp= getappdata(mainFig, 'targetTemp');
    myTemp= getappdata(mainFig, 'myTemp');
    
%   Read target temperature
    targetTemp= str2double(get(targetTemp, 'String')); 
    
%   Read IR sensor
    newTempIR=str2double(get(TempIndIR, 'String'));
       
%   Read NTC sensor
    newTempNTC=str2double(get(TempIndNTC(1), 'String'));
    
%   Use Peltier as heater
    posWindow= feedbackPar(1); % switch off if deltaT is above this
    negWindow= feedbackPar(2); % switch on if deltaT is below this
    negExtreme= feedbackPar(3); % worst case negative delta (full power).
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

%   Calculate delta temperature (sensor - targetTemp)   
    deltaT= newTemperature - targetTemp;
    fprintf('Target T= %2.1f, T(sensor)= %2.1f, DeltaT=%2.1f\n', targetTemp, newTemperature, deltaT);
    
%   Action based on value of deltaT
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
%%  INITPELTIERTHERMOSTAT Initialize the thermostat timer
%   At least display a message on the command window
    disp('peltier Thermostat timer started');
end

function stopPeltierThermostat(obj, ~, mainFig)
%%  STOPPELTIERTHERMOSTAT Executed when the temperature timer stops
%   Display message
    fprintf('peltier Thermostat timer stopped\n');
end

