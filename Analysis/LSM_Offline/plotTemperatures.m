function [ output_args ] = plotTemperatures( tempHaxes, tempTs, peltierTs )
 %% PLOTTEMPERATURES Plot the temperature timeseries
 %
    writetofile=0;
    labels= {'IR', 'INT.', 'INTAKE', 'EXT.', 'PELT.%'};
    
    tempTs.TimeInfo.Units = 'hours';
    tempTs.TimeInfo.Format = 'dd mmm, HH:MM';
    %ts.TimeInfo.StartDate = ts.UserData;
    tempTs.Time = 24*(tempTs.Time - tempTs.Time(1));
    tempTs.Name= 'Temperature';
    
    peltierTs.TimeInfo.Units = 'hours';
    peltierTs.TimeInfo.Format = 'dd mmm, HH:MM';
    %ts.TimeInfo.StartDate = ts.UserData;
    peltierTs.Time = 24*(peltierTs.Time - peltierTs.Time(1));
    peltierTs.Name= 'Peltier Power';
    
    % Smoothing
    a = 1;
    windowSize = 5; %N. of samples to use in moving average.
    b = (1/windowSize)*ones(1,windowSize);
    %b = [1/4 1/4 1/4 1/4];
    for i=1:4
        tempTs.Data(:,i) = filter(b,a, tempTs.Data(:,i));
    end    
    
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
    myPlot(2).LineStyle= '-';
    myPlot(3).Color= [0.9290 0.6940 0.1250];%Mustard yellow
    myPlot(3).LineStyle= '-';
    myPlot(4).Color= [0.4940 0.1840 0.5560]; %Purple
    myPlot(4).LineStyle= '-';
    
    % PLOT STYLE
    xlabel(tempHaxes, 'Time [h]') ;
    ylabel(tempHaxes, 'Temperature [C]') ;
    legend(tempHaxes, 'PELT.PWR', 'IR', 'INT', 'INTAKE', 'EXT', 'Location', 'northwest', 'Orientation', 'horizontal');
    tempHaxes.XMinorTick= 'on';
    tempHaxes.XGrid= 'on';
    tempHaxes.XMinorGrid= 'on';
    tempHaxes.YMinorGrid= 'on';
    tempHaxes.YGrid= 'on';
    ylim(tempHaxes, [20, 25]);
    
    % Legend
    legend(labels{1}, labels{2}, labels{3}, labels{4}, 'orientation', 'horizontal', 'location', 'northwest');
    [length,~]=size(tempTs.Data(:,2));
    

end

