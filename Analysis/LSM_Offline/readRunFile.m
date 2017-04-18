function [ tempTs, peltierTs ] = readRunFile( myFolder, myMatfile )
 %% READRUNFILE Read the file saved at the end of a run. Return its content
 %  

    
    % LOAD THE FILE
    fileData= load([myFolder myMatfile]);
    
    % LIST ALL ELEMENTS IN FILE
    % THERE SHOULD BE A MAIN BRANCH...
    mainBranch = fieldnames(fileData);
    
    % ... WITH SEVERAL SUB-BRANCHES
    subBranch= fileData.(mainBranch{1});
    
    % RETRIEVE TIMESERIES FOR TEMPERATURE
    tempTs= subBranch.tempTs;
    
    % RETRIEVE TIMESERIES FOR PELTIER
    peltierTs= subBranch.peltierTs;
    
end

