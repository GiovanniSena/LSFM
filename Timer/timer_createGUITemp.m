function [ temperatureGUITimer ] = timer_createGUITemp( varargin)
 %% TIMER_CREATETEMP Create timer object to measure temperature
 %  This object is in charge of updating the temperature DISPLAY in the main
 %  GUI. The period used to read the probe is fixed to 8 seconds.
    
    temperatureGUITimer = timer;
    
    configData= getappdata(varargin{1}, 'confPar');
    temp_offset = str2double(configData.temperature.temp_offset);
    temp_conversion = str2double(configData.temperature.temp_conversion);
    temp_update = str2double(configData.temperature.temp_update);
    sampleN= str2double(configData.temperature.temp_avgsamp);
    % The sensors cannot update faster than once every 4 seconds. Let's keep
    % it safe and use 6 seconds periods as a minimum.
    if (temp_update <6)
        temp_update=6;
    end
    
    temperatureGUITimer.StartDelay = 0;
    temperatureGUITimer.Period = temp_update;
    temperatureGUITimer.ExecutionMode = 'fixedRate';
    
    temperatureGUITimer.TimerFcn = {@updateGUITemperature, varargin{1}, temp_offset, temp_conversion, sampleN};
    temperatureGUITimer.StartFcn = @initGUITempTimer;
    temperatureGUITimer.StopFcn = {@stopGUITempTimer, varargin{1}};
    setappdata(varargin{1}, 'temperatureGUITimer', temperatureGUITimer);

end

function updateGUITemperature( obj, event, mainFig, offset, conversion, sampleN)
%function updateTemperature( obj, ~, tempTs, tempHaxes )
 %% UPDATETEMPERATURE Summary of this function goes here
 %  This function updates the temperature indicators on the main panel.
 %  The infrared indicator is the average of the last 6 samples, taken
 %  every N seconds (defined in temp_update). For the NTC indicator we use the current values (since they are averaged in the arduino over 15 readings).
    
    nSensors=3; % Number of NTC temperature sensors
    
    TempIndIR= getappdata(mainFig, 'TempIndIR');
    TempIndNTC= getappdata(mainFig, 'TempIndNTC');
    
    
    
    % We want to probe the IR sensor only if the LEDs are off, so we
    % retrieve the state of the LED cluster.
    ledobj= getappdata(mainFig, 'ledobj'); 
    ledhandl= getappdata(mainFig, 'ledhandl' );
    LED1status= LED_readStatus(ledobj, ledhandl, 4);
    LED2status= LED_readStatus(ledobj, ledhandl, 5);
    LEDstatus= LED1status && LED2status;
    
    myTemp= getappdata(mainFig, 'myTemp');
    newTempIR= tempHW_getT_IR(myTemp);
    newTempNTC= [-300, -300, -300];
    for iSensor=1: nSensors
        newTempNTC(iSensor)= tempHW_getT_NTC(myTemp, iSensor-1);
    end
    
  % USE CALIBRATION?
    %disp('No calibration temp')
    newTempIR= newTempIR*conversion + offset;
    
  % PUT NEW IR VALUE IN ARRAY TO AVERAGE IT (but only if good value and
  % LEDs are off)
    %if (newTempIR > 0)&&(LEDstatus==0)
    if (newTempIR > 0)
        obj.UserData= [obj.UserData newTempIR];
    end
    
  
  % ONLY STORE N-EVENTS IN IR-ARRAY (REMOVE OLDEST EVENT)
    %sampleN= 6;
    [~, dim]=size(obj.UserData);
    if (dim > sampleN)
        tmpArray= obj.UserData;
        tmpArray(1)= [];
        obj.UserData= tmpArray;
    end
    
  % CONVERT IR_TEMP TO STRING TO FEED TO INDICATOR
    meanT= mean(obj.UserData);
    newTempStr= num2str(meanT, '%2.1f');
    set(TempIndIR, 'String', newTempStr);
       
  % CONVERT NTC_TEMP TO STRING TO FEED TO INDICATOR
    for iSensor=1: nSensors
        newTempStr= num2str(newTempNTC(iSensor), '%2.1f');
        set(TempIndNTC(iSensor), 'String', newTempStr);
    end
    
end

function initGUITempTimer(obj, ~)
 %% Initialize the temperature timer
 %  Create the time series and store it in the timer UserData so that it
 %  can be updated across different executions.
    
    %tempTs= timeseries('Temperature');
    %tempTs.TimeInfo.StartDate= now; % <-FOR SOME REASON THIS IS BUGGED AND
                                     % SHOWS A WRONG DATE
    %tempTs.UserData= datetime('now');% SO I PUT THE START DATE IN USERDATA INSTEAD
    
    %obj.UserData = tempTs;
    
    disp('GUITemp series initialised');
    obj.UserData= [];
    %configData= getappdata(gcf, 'confPar');
   
    %temp_period = configData.pump.temp_period;
    %disp('TEMP PERIOD');
    %disp(temp_period);
   
end

function stopGUITempTimer(obj, ~, mainFig)
 %% Executed when the temperature timer stops

 
end

