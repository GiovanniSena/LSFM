function [ output_args ] = saveTemperaturesTxt(myFolder, myMatfile, tempTs, peltierTs )
 %% SAVETEMPERATURESTXT Create a txt with the data from the time series
 %  Detailed explanation goes here

    outFile= strrep( myMatfile, '.mat', '.txt');
    
    IRVec= tempTs.Data(:,1);
    IntVec= tempTs.Data(:,2);
    IntakeVec= tempTs.Data(:,3);
    ExtVec= tempTs.Data(:,4);
    peltVec= peltierTs.Data(:,1);
    
    fileID = fopen([myFolder outFile],'w');
    [length,~]=size(tempTs.Data(:,2));
    for i=1:length
            fprintf(fileID, '%f %f %f %f %f %f\n', tempTs.Time(i), IRVec(i), IntVec(i), IntakeVec(i), ExtVec(i), peltVec(i));
    end
    fclose(fileID);
end

