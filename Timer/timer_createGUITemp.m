function [ temperatureGUITimer ] = timer_createGUITemp( varargin)
%%  TIMER_CREATETEMP Create timer object to poll temperature sensors.
%   This timer is in charge of updating the temperature DISPLAY in the main
%   GUI.
%   The timer parameters are retrieved from the user settings in the
%   configuration data.

%   Create timer
    temperatureGUITimer = timer;
%   Set timer parameter    
    configData= getappdata(varargin{1}, 'confPar');
    temp_offset = str2double(configData.temperature.temp_offset);
    temp_conversion = str2double(configData.temperature.temp_conversion);
    temp_update = str2double(configData.temperature.temp_update);
    sampleN= str2double(configData.temperature.temp_avgsamp);
%   The sensors cannot update faster than once every 4 seconds. To keep it
%   safe, the minimum period is 6 seconds. Any value smaller than this will
%   be coerced to 6.
    if (temp_update <6)
        temp_update=6;
    end
    temperatureGUITimer.StartDelay = 0;
    temperatureGUITimer.Period = temp_update;
    temperatureGUITimer.ExecutionMode = 'fixedRate';
%   Assign timer functions    
    temperatureGUITimer.TimerFcn = {@updateGUITemperature, varargin{1}, temp_offset, temp_conversion, sampleN};
    temperatureGUITimer.StartFcn = @initGUITempTimer;
    temperatureGUITimer.StopFcn = {@stopGUITempTimer, varargin{1}};
    setappdata(varargin{1}, 'temperatureGUITimer', temperatureGUITimer);

end

function updateGUITemperature( obj, event, mainFig, offset, conversion, sampleN)
%%  UPDATETEMPERATURE Function executed periodically to retrieve temperature values.
%   This function updates the temperature indicators on the main panel.
%   The infrared indicator is the average of the last (sampleN) samples, taken
%   every N seconds (defined in temp_update).
%   For the NTC indicator we use the current values (since they are averaged in the arduino over 15 readings).
    
%   Retrieve parameters
    nSensors=3; % Number of NTC temperature sensors
    TempIndIR= getappdata(mainFig, 'TempIndIR');
    TempIndNTC= getappdata(mainFig, 'TempIndNTC');

%   To avoid false reading, we want to probe the IR sensor only if the LEDs
%   are off.
%   Retrieve the state of the LED cluster.
    ledobj= getappdata(mainFig, 'ledobj'); 
    ledhandl= getappdata(mainFig, 'ledhandl' );
    LED1status= LED_readStatus(ledobj, ledhandl, 4);
    LED2status= LED_readStatus(ledobj, ledhandl, 5);
    LEDstatus= LED1status && LED2status;
    
%   Read temperature sensors
    myTemp= getappdata(mainFig, 'myTemp');
    newTempIR= tempHW_getT_IR(myTemp);
    newTempNTC= [-300, -300, -300];
    for iSensor=1: nSensors
        newTempNTC(iSensor)= tempHW_getT_NTC(myTemp, iSensor-1);
    end
    
%   Adjust IR reading based on user-defined calibration
    newTempIR= newTempIR*conversion + offset;
    
%   Add IR reading to array to average it.
    if (newTempIR > 0)
        obj.UserData= [obj.UserData newTempIR];
    end
    
  
%   Keep last (sampleN) reading in array. Remove oldest one
    [~, dim]=size(obj.UserData);
    if (dim > sampleN)
        tmpArray= obj.UserData;
        tmpArray(1)= [];
        obj.UserData= tmpArray;
    end
    
%   Convert readings to strings. Update respective indicators.
    meanT= mean(obj.UserData);
    newTempStr= num2str(meanT, '%2.1f');
    set(TempIndIR, 'String', newTempStr);
       
    for iSensor=1: nSensors
        newTempStr= num2str(newTempNTC(iSensor), '%2.1f');
        set(TempIndNTC(iSensor), 'String', newTempStr);
    end
end

function initGUITempTimer(obj, ~)
%%  INITGUITEMPTIMER Initialize the temperature timer
%   When the time series is created, initialize the the timer UserData so that it
%   can be updated across different executions.
    
    disp('GUITemp series initialised');
    obj.UserData= [];
end

function stopGUITempTimer(obj, ~, mainFig)
%%  STOPGUITEMPTIMER Executed when the temperature timer stops
end

