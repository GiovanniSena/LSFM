function [ temperatureTimer ] = timer_createTemp( varargin)
 %% TIMER_CREATETEMP Create timer object to measure temperature
 %  This object is in charge of updating the temperature PLOT in the main
 %  GUI. The period used to read the probe is determinet by the value of
 %  the "temp_period" parameter in the config file.
 
    temperatureTimer = timer;
    
   
    
    configData= getappdata(gcf, 'confPar');
    temp_period = configData.temperature.temp_perioddisp; %This is read from the config file and dictates how often the plots are updated on the graph.
    
    temperatureTimer.StartDelay = 0;
    temperatureTimer.Period = str2double(temp_period);
    temperatureTimer.ExecutionMode = 'fixedRate';
    
    temperatureTimer.TimerFcn = {@updateTemperature, gcf};
    temperatureTimer.StartFcn = @initTempTimer;
    temperatureTimer.StopFcn = {@stopTempTimer, gcf};
    setappdata(gcf, 'temperatureTimer', temperatureTimer);

end

function updateTemperature( obj, event, mainFig)
%function updateTemperature( obj, ~, tempTs, tempHaxes )
 %% UPDATETEMPERATURE Update the temperature time series with the values read from the fron panel indicators.
 %  Detailed explanation goes here
    
    
    tempHaxes= getappdata(mainFig, 'tempHaxes');
    %myTemp= getappdata(mainFig, 'myPump');
    TempIndIR= getappdata(mainFig, 'TempIndIR');
    TempIndNTC= getappdata(mainFig, 'TempIndNTC');
    myTemp= getappdata(mainFig, 'myTemp');
    
    % READ TIME
    c= now;
    
    % READ PELTIER POWER
    peltPower= tempHW_getPeltier(myTemp);
    
    % READ TEMPERATURE FROM THE DISPLAY
    %newTemp= pump_getT(myPump)
    newTemp1= str2double(get(TempIndIR, 'String')); 
    
       % This part is ugly...
    newTemp2= str2double(get(TempIndNTC(1), 'String')); 
    newTemp3= str2double(get(TempIndNTC(2), 'String')); 
    newTemp4= str2double(get(TempIndNTC(3), 'String')); 
    
    newTemp= [newTemp1 newTemp2 newTemp3 newTemp4];
    % RETRIEVE TIMESERIES
    myData= obj.UserData;
    tempTs = myData.tempTs;
    peltierTs= myData.peltierTs;
    %beginTime=tempTs.UserData % This is the date of creation of the timeseries.
    
    if ((newTemp1 ~= -300)&&(newTemp2 ~= -300)&&(newTemp3 ~= -300)&&(newTemp4 ~= -300))
        %obj.UserData = tempTs.addsample('Time', c , 'Data', newTemp);
        tempTs = tempTs.addsample('Time', c , 'Data', newTemp);
        peltierTs= peltierTs.addsample('Time', c , 'Data', peltPower);
    end
    myData.tempTs= tempTs;
    myData.peltierTs= peltierTs;
    obj.UserData= myData;
    %%tempTs.Time = 86400*(tempTs.Time - tempTs.Time(1)); %display time in seconds
    tempTs.Time = 24*(tempTs.Time - tempTs.Time(1)); %display time in hours
    peltierTs.Time= 24*(peltierTs.Time - peltierTs.Time(1));
    
  % SMOOTHEN THE IR SERIES
    weight = 1;
    windowSize = 3; %N. of samples to use in moving average.
    denominator = (1/windowSize)*ones(1,windowSize);%denominator = [1/n 1/n 1/n 1/n ... 1/n]; n-times, with n= windowSize
    tempTs.Data(:,1) = filter(denominator, weight, tempTs.Data(:,1));
  
  % PLOT THE PELTIER POWER
    leftColor= [0 0 0];
    yyaxis(tempHaxes, 'left');
    plot(peltierTs,  'Parent', tempHaxes, 'Color',leftColor, 'LineStyle', ':');
    tempHaxes.YColor = leftColor;
    ylabel(tempHaxes, 'Peltier Power [%]') ;
    ylim(tempHaxes, [0, 100]);
        
  % PLOT THE TIME SERIES
    rightColor= [1 0 0];
    yyaxis(tempHaxes, 'right');
    myPlot= plot(tempTs,  'Parent', tempHaxes, 'Color',rightColor);
    tempHaxes.YColor = [0 0 0];
    myPlot(1).Color= [0 0.4470 0.7410]; %Light blue
    myPlot(1).LineStyle= '-';
    myPlot(2).Color= [0.8500 0.3250 0.0980]; %Orange
    myPlot(2).LineStyle= '-.';
    myPlot(3).Color= [0.9290 0.6940 0.1250];%Mustard yellow
    myPlot(3).LineStyle= '--';
    myPlot(4).Color= [0.4940 0.1840 0.5560]; %Purple
    myPlot(4).LineStyle= ':';
    
    %datetick(tempHaxes,'x', 'dd HH:MM');
  % PLOT STYLE
    xlabel(tempHaxes, 'Time [h]') ;
    ylabel(tempHaxes, 'Temperature [C]') ;
    legend(tempHaxes, 'PELT.PWR', 'IR', 'INT', 'INTAKE', 'EXT', 'Location', 'southeast', 'Orientation', 'horizontal');
    tempHaxes.XMinorTick= 'on';
    tempHaxes.XGrid= 'on';
    tempHaxes.XMinorGrid= 'on';
    tempHaxes.YMinorGrid= 'on';
    tempHaxes.YGrid= 'on';
    ylim(tempHaxes, [20, 28]);
    %datetick(tempHaxes,'x', 'mm-dd HH:MM');
    
    
end

function initTempTimer(obj, ~)
 %% Initialize the temperature timer
 %  Create the time series and store it in the timer UserData so that it
 %  can be updated across different executions.
    
    tempTs= timeseries('Temperature');
    peltierTs= timeseries('Peltier');
    %tempTs.TimeInfo.StartDate= now; % <-FOR SOME REASON THIS IS BUGGED AND
                                     % SHOWS A WRONG DATE
    tempTs.UserData= datetime('now');% SO I PUT THE START DATE IN USERDATA INSTEAD
    peltierTs.UserData= datetime('now');
    
    myData= struct('tempTs', tempTs, 'peltierTs', peltierTs);
    obj.UserData = myData;
    
    disp('Temp series initialised');
   
    configData= getappdata(gcf, 'confPar');
   
    %temp_period = configData.temperature.temp_perioddisp;
    %disp('TEMP PERIOD');
    %disp(temp_period);
   
end

function stopTempTimer(obj, ~, mainFig)
 %% Executed when the temperature timer stops
 %  Save the collected data to a file.
    
    myData= obj.UserData;
    tempTs = myData.tempTs; %#ok<NASGU>
    peltierTs = myData.peltierTs; %#ok<NASGU>
    confPar=getappdata(mainFig, 'confPar');
    saveDir= confPar.application.savedir;
    runNum= str2num(confPar.user.run);
    fileName= strcat(saveDir, 'Run', num2str(runNum, '%04d'), '_Temperature.mat'  );
    %save(fileName, 'tempTs');
    save(fileName, 'myData');
end

