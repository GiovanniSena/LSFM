function [ output_args ] = displayTemperatures( input_args )
%%  DISPLAYTEMPERATURES Create a plot with the temperatures and peltier power.
%   Retrieve the data from the *.mat file saved by the LSFM software.  
    
%   Load data
    myFolder= '\\155.198.145.28\Paolo_NAS\LSM_Data\160304_TemperatureScanSimulation\';
    myMatfile= '160401_Run0001_Temperature.mat' ;
    [ tempTs, peltierTs ]= readRunFile( myFolder, myMatfile );

%   Create figure
    scrsz = get(groot,'ScreenSize');
    tempFigure =figure('Position',[10 scrsz(4)/5 scrsz(3)/1.1 scrsz(4)/1.4]);
    myAxes= axes('parent', tempFigure);
    
%   Plot temperature
    plotTemperatures(myAxes, tempTs, peltierTs);
    
%   Save data to txt
    savetofile=0;
    if savetofile
        saveTemperaturesTxt(myFolder, myMatfile, tempTs, peltierTs);
    end
end

