function [ output_args ] = displayTemperatures( input_args )
 %% DISPLAYTEMPERATURES Create a plot with the temperatures and peltier power.
 %  
    
    % LOAD DATA
    myFolder= '\\155.198.145.28\Paolo_NAS\LSM_Data\160304_TemperatureScanSimulation\';
    myMatfile= '160401_Run0001_Temperature.mat' ;
    [ tempTs, peltierTs ]= readRunFile( myFolder, myMatfile );

    % CREATE FIGURE
    scrsz = get(groot,'ScreenSize');
    tempFigure =figure('Position',[10 scrsz(4)/5 scrsz(3)/1.1 scrsz(4)/1.4]);
    myAxes= axes('parent', tempFigure);
    
    % PLOT THE TEMPERATURES
    plotTemperatures(myAxes, tempTs, peltierTs);
    
    % SAVE DATA TO TXT
    savetofile=0;
    if savetofile
        saveTemperaturesTxt(myFolder, myMatfile, tempTs, peltierTs);
    end

end

