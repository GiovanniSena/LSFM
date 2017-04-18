function [ output_args ] = plotTemperatures( myMatfile )
 %% PLOTTEMPERATURES Plot the temperature timeseries
 %
    writetofile=0;
    myFolder= '\\155.198.145.28\Paolo_NAS\LSM_Data\160304_TemperatureScanSimulation\';
    myMatfile= {'160401_Run0001_Temperature.mat' };
    labels= {'IR', 'INT.', 'INTAKE', 'EXT.', 'PELT.%'};
    [nFiles,~]=size(myMatfile)
    for i=1:nFiles
        fileData= load([myFolder myMatfile{i}]);

        % List the object names in the file
        names = fieldnames(fileData);

        % Extract the name of the time series
        myTsName= char(names(1));
        

        % Copy the time series in a new object
        myTs(i)= fileData.(myTsName);
        
        myTsName= char(names(2));
        myPelt(i)=fileData.(myTsName);
    end
    myData
    ts = append(myTs(1));
    
    %ts= myTs(1)
    %ts= myTs(3);
    ts.TimeInfo.Units = 'hours';
    ts.TimeInfo.Format = 'dd mmm, HH:MM';
    %ts.TimeInfo.StartDate = ts.UserData;
    ts.Time = 24*(ts.Time - ts.Time(1));
    ts.Name= 'Temperature';
    
    % Smoothing
    a = 1;
    windowSize = 5; %N. of samples to use in moving average.
    b = (1/windowSize)*ones(1,windowSize);
    %b = [1/4 1/4 1/4 1/4];
    for i=1:4
        %ts.Data(:,i) = filter(b,a, ts.Data(:,i));
    end    
    % Plot the time series
    scrsz = get(groot,'ScreenSize');
    %myFigure=figure('Position',[10 scrsz(4)/5 scrsz(3)/1.1 scrsz(4)/1.4]);
    myFigure=figure('Position',[10 20 1400 900]);
    
    myAxes= axes('parent', myFigure);
    yyaxis(myAxes, 'left');
    myAxes.YColor = [0 0 1];
    myAxes.YLabel.String= 'Peltier Power [%]';
    ylim(myAxes, [0, 100]);
    
    yyaxis(myAxes, 'right');
    myAxes.YColor = [0 0 0];
    myPlot= plot(ts);
    myPlot(1).Color= [0.5 0.5 0.5];
    myPlot(1).LineStyle= '-';
    myPlot(2).Color= [0.7 0.7 0.];
    myPlot(2).LineStyle= '--';
    myPlot(3).Color= [1 0.5 0.5];
    myPlot(3).LineStyle= ':';
    
    
    %set(gca,'Position',[0 0 1 1])
    myAxes.Title.String= 'Temperature Monitor';
    myAxes.Position= [0.05 0.15 0.9 0.8];
    myAxes.YLabel.String= 'Temperature [C]';
    myAxes.XMinorTick= 'on';
    myAxes.XGrid= 'on';
    myAxes.XMinorGrid= 'on';
    myAxes.YMinorGrid= 'on';
    myAxes.XTickLabelRotation= 60;
    %ylim manual
    %ylim(ax2,[-10 10])
    ylim(myAxes, [20, 30]);
    
    % Legend
    legend(labels{1}, labels{2}, labels{3}, labels{4}, 'orientation', 'horizontal', 'location', 'northwest');
    [length,~]=size(ts.Data(:,2));
    
    % Write to txt
    outFile= strrep( myMatfile{1}, '.mat', '.txt');
    IRVec= ts.Data(:,1);
    intakeVec= ts.Data(:,3);
    if (writetofile)
        fileID = fopen([myFolder outFile],'w');
        for i=1:length
            fprintf(fileID, '%f %f %f\n', ts.Time(i), IRVec(i), intakeVec(i));
        end
        fclose(fileID);
    end
    
    % Cross correlation between the two data sets
    [acor,lag] = xcorr(IRVec, intakeVec, 1);
    %figure
    %plot(lag,acor)
    [~,I] = max(abs(acor));
    lagDiff = lag(I)
    
    % Plot difference between values
    diffVec= IRVec - intakeVec;
    %figure
    %plot(diffVec)
end

