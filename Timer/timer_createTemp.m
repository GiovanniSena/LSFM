function [ temperatureTimer ] = timer_createTemp( varargin)
%%  TIMER_CREATETEMP Create timer object to measure temperature
%   This object is in charge of updating the temperature PLOTs in the main
%   GUI. The period used to read the probe is determined by the value of
%   the "temp_period" parameter in the config file.
 
%   Create timer
    temperatureTimer = timer;
    
%   Retrieve and set timer parameters
    configData= getappdata(gcf, 'confPar');
    temp_period = configData.temperature.temp_perioddisp; %This is read from the config file and dictates how often the plots are updated on the graph.
    
    temperatureTimer.StartDelay = 0;
    temperatureTimer.Period = str2double(temp_period);
    temperatureTimer.ExecutionMode = 'fixedRate';
%   Define timer functions
    temperatureTimer.TimerFcn = {@updateTemperature, gcf};
    temperatureTimer.StartFcn = @initTempTimer;
    temperatureTimer.StopFcn = {@stopTempTimer, gcf};
%   Add timer to GUI application data
    setappdata(gcf, 'temperatureTimer', temperatureTimer);
end

function updateTemperature( obj, event, mainFig)
%%  UPDATETEMPERATURE Update the temperature time series with the values read from the front panel indicators.
%   Note that the temperature visualized in the plots are not the raw
%   values read from the sensors but the smoothed values stored in the GUI
%   display.
    
%   Retrieve indicator handles    
    tempHaxes= getappdata(mainFig, 'tempHaxes');
    TempIndIR= getappdata(mainFig, 'TempIndIR');
    TempIndNTC= getappdata(mainFig, 'TempIndNTC');
    myTemp= getappdata(mainFig, 'myTemp');
    
%	Current time
    c= now;
    
%   Read current Peltier cell power
    peltPower= tempHW_getPeltier(myTemp);
    
%   Read temperatures from their displays on the GUI
    newTemp1= str2double(get(TempIndIR, 'String')); 
    
%   Convert values to numbers
    newTemp2= str2double(get(TempIndNTC(1), 'String')); 
    newTemp3= str2double(get(TempIndNTC(2), 'String')); 
    newTemp4= str2double(get(TempIndNTC(3), 'String')); 
    
%   Store values in array    
    newTemp= [newTemp1 newTemp2 newTemp3 newTemp4];

%   Retrieve timeseries objects used for plots
    myData= obj.UserData;
    tempTs = myData.tempTs;
    peltierTs= myData.peltierTs;

%   Remove error values. Add good values to time series
    if ((newTemp1 ~= -300)&&(newTemp2 ~= -300)&&(newTemp3 ~= -300)&&(newTemp4 ~= -300))
        tempTs = tempTs.addsample('Time', c , 'Data', newTemp);
        peltierTs= peltierTs.addsample('Time', c , 'Data', peltPower);
    end
%   Store time series in the object's data so that it can be passed between
%   cycles
    myData.tempTs= tempTs;
    myData.peltierTs= peltierTs;
    obj.UserData= myData;
%   Manipulate time stamp to display hours from start of series
    tempTs.Time = 24*(tempTs.Time - tempTs.Time(1)); %display time in hours
    peltierTs.Time= 24*(peltierTs.Time - peltierTs.Time(1));
    
%	Smoothen IR sensor data with moving average
    weight = 1;
    windowSize = 3; %N. of samples to use in moving average.
    denominator = (1/windowSize)*ones(1,windowSize);%denominator = [1/n 1/n 1/n 1/n ... 1/n]; n-times, with n= windowSize
    tempTs.Data(:,1) = filter(denominator, weight, tempTs.Data(:,1));
  
%	Plot Peltier cell power
    leftColor= [0 0 0];
    yyaxis(tempHaxes, 'left');
    plot(peltierTs,  'Parent', tempHaxes, 'Color',leftColor, 'LineStyle', ':');
    tempHaxes.YColor = leftColor;
    ylabel(tempHaxes, 'Peltier Power [%]') ;
    ylim(tempHaxes, [0, 100]);
        
%   Plot temperature time series
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
    
    
%	Update plot style
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
%%  INITTEMPTIMER Initialize the temperature timer
%   Create the time series and store it in the timer UserData so that it
%   can be updated across different executions.

%   Create time series
    tempTs= timeseries('Temperature');
    peltierTs= timeseries('Peltier');
    
%   Store the begin time in user data 
    tempTs.UserData= datetime('now');
    peltierTs.UserData= datetime('now');

%   Store time series in timer's data    
    myData= struct('tempTs', tempTs, 'peltierTs', peltierTs);
    obj.UserData = myData;
    
    disp('Temp series initialised');
    %configData= getappdata(gcf, 'confPar');
    %temp_period = configData.temperature.temp_perioddisp;
    %disp('TEMP PERIOD');
    %disp(temp_period);
end

function stopTempTimer(obj, ~, mainFig)
%%  STOPTEMPTIMER Executed when the temperature timer stops
%   Save the collected data to a file.

%   Retrieve timer data
    myData= obj.UserData;
    tempTs = myData.tempTs; %#ok<NASGU>
    peltierTs = myData.peltierTs; %#ok<NASGU>
%   Retrieve save folder
    confPar=getappdata(mainFig, 'confPar');
    saveDir= confPar.application.savedir;
%   Create file name base on current run and save the data to it
    runNum= str2num(confPar.user.run);
    fileName= strcat(saveDir, 'Run', num2str(runNum, '%04d'), '_Temperature.mat'  );
    save(fileName, 'myData');
end

