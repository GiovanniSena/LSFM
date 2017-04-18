function [ output_args ] = TS_writeToTxt( timeSeries, filename )
 %% TS_WRITETOTXT Writes the timeseries in a txt file
 %   Detailed explanation goes here

    filename= 'D:\LSM_Data\test.txt'; % <-COMMENT WHEN DONE TESTING
    timeSeries= importdata('D:\LSM_Data\Run1_Temperature.mat'); % <-COMMENT WHEN DONE TESTING
    
 % OPEN OUTPUT FILE    
    fid = fopen(filename, 'w') ;
 
 % RETRIEVE INFO FROM TIME SERIES   
    tsName = timeSeries.Name;
    tsDUnits= 'Temp (C)';
    tsTUnits= timeSeries.TimeInfo.Units;
    tsStartDate= timeSeries.UserData;
    myData= timeSeries.Data;
 
 % WRITE FILE HEADER
    fprintf(fid, '%s \t %s \t %s\n', 'Date', 'Time', tsDUnits);
 
 % SPECIFY FORMAT FOR TIME STAMP   
    formatOut = 'yy-mm-dd \t HH:MM:SS';
 
 % WRITE DATA TO FILE
    for iLine = 1:size(myData, 1) % Loop through each time/value row
        newTime=  datestr(timeSeries.Time(iLine), formatOut);
        fprintf(fid, '%s \t %8.3f \n', newTime, myData(iLine)) ; % Print the data values
    end

 % CLOSE OUTPUT FILE
    fclose(fid) ;
   %fclose('all'); % IN CASE OF FILE LOCKED
end

