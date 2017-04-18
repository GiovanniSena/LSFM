function [ output_args ] = plotRootMovement( myFolder )
 %% PLOTROOTMOVEMENT Summary of this function goes here
 %   Detailed explanation goes here
 
    doMIP= 0;

    myFolder= 'S:\LiSM data\161124\originals\';
    fileList= listFilesInFolder(myFolder);
    
    resultsFolder= [myFolder 'results\'];
    mkdir(resultsFolder);
    
    [nFiles,~] =size(fileList);
    
    deltaX= zeros(nFiles, 1);
    deltaY= zeros(nFiles, 1);
    deltaZ= zeros(nFiles, 1);
    deltaS= zeros(nFiles, 1);
    
    cumulX= zeros(nFiles, 1);
    cumulY= zeros(nFiles, 1);
    cumulZ= zeros(nFiles, 1);
    timeVector= zeros(nFiles, 1);
    
    for i= 1:nFiles
      % ADD NEW FIELD TO STRUCTURE WITH THE LOG FILE NAME
        fileList(i).log= strrep(fileList(i).name, '.tif', '.txt');
        datetime(fileList(i).datenum, 'ConvertFrom', 'datenum');
        
        deltaMatrix= retrieveBestA([myFolder fileList(i).log]);
        
        timeVector(i)= fileList(i).datenum;
        deltaX(i)= deltaMatrix(4,2);
        deltaY(i)= deltaMatrix(4,3);
        deltaZ(i)= deltaMatrix(4,1);
        if (i==1)
            cumulX(i)= deltaMatrix(4,2);
            cumulY(i)= deltaMatrix(4,3);
            cumulZ(i)= deltaMatrix(4,1);
        else
            cumulX(i)= cumulX(i-1)+deltaMatrix(4,2);
            cumulY(i)= cumulY(i-1)+deltaMatrix(4,3);
            cumulZ(i)= cumulZ(i-1)+deltaMatrix(4,1);
        end
        deltaS(i)= sqrt( deltaX(i)*deltaX(i) +  deltaY(i)*deltaY(i) + deltaZ(i)*deltaZ(i) );
        
        if (doMIP)
            tempMIP= createMIP(myFolder, fileList(i).name);
            outFile = strrep(fileList(i).name, '.tif', '_MIP.tif');
            outFile= [resultsFolder outFile]; %#ok<AGROW>
            TIFF_write(tempMIP, outFile);
        end
    end
    
    hFig = figure(1);
    dtAxis= subplot(1,2,1);
    cumulAxis= subplot(1,2,2);
    set(hFig, 'Position', [10 10 1600 600])
    
    plot(dtAxis, timeVector, deltaX);
    datetick('x','yyyy-mm-dd HH:MM:SS', 'keeplimits');
    xlabel(dtAxis, 'Time');
    ylabel(dtAxis, 'Displacement [mm]'); 
    hold(dtAxis, 'on');
    plot(dtAxis, timeVector,  deltaY);
    hold(dtAxis, 'on');
    plot(dtAxis, timeVector,  deltaZ);
    hold(dtAxis, 'on');
    plot(dtAxis, timeVector,  deltaS);
    legend(dtAxis, 'deltaX', 'deltaY', 'deltaZ', 'deltaS');
    
    plot(cumulAxis, timeVector, cumulX);
    %datetick('x','yyyy-mm-dd HH:MM:SS', 'keeplimits');
    %datetick('x','HH', 'keeplimits');
    xlabel(cumulAxis, 'Time');
    ylabel(cumulAxis, 'Position [mm]');
    hold(cumulAxis, 'on');
    plot(cumulAxis, timeVector,  cumulY);
    hold(cumulAxis, 'on');
    plot(cumulAxis, timeVector,  cumulZ);
    legend(cumulAxis, 'PosX', 'PosY', 'PosZ');
    
    
    %saveTightFigure(hFig, [resultsFolder 'output.pdf']);
    hold(dtAxis, 'off');
    hold(cumulAxis, 'off');
   
end

