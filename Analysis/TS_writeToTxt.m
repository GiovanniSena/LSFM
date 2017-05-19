function [ output_args ] = TS_writeToTxt( timeSeries, filename )
%%  TS_WRITETOTXT Writes the content of a timeseries to a txt file

%    filename= 'D:\LSM_Data\test.txt'; % <-COMMENT WHEN DONE TESTING
%    timeSeries= importdata('D:\LSM_Data\Run1_Temperature.mat'); % <-COMMENT WHEN DONE TESTING
    
%   Open output file
    fid = fopen(filename, 'w') ;
 
%   Retrieve data from time series
    tsName = timeSeries.Name;
    tsDUnits= 'Temp (C)';
    tsTUnits= timeSeries.TimeInfo.Units;
    tsStartDate= timeSeries.UserData;
    myData= timeSeries.Data;
 
%   Write file header
    fprintf(fid, '%s \t %s \t %s\n', 'Date', 'Time', tsDUnits);
 
%   Specify time stamp format
    formatOut = 'yy-mm-dd \t HH:MM:SS';
 
%   Write data to file
    for iLine = 1:size(myData, 1) % Loop through each time/value row
        newTime=  datestr(timeSeries.Time(iLine), formatOut);
        fprintf(fid, '%s \t %8.3f \n', newTime, myData(iLine)) ; % Print the data values
    end

%   CLOSE OUTPUT FILE
    fclose(fid) ;
end

