function [ finePosition ] = tr_interpolateFocusPos( PosArray, sharpValArray )
 %% TR_INTERPOLATEFOCUSPOS Given a vector of position and focus values, find the local maximum position
 %  The focus measure can be modelled as a quadratic function around its
 %  maximum (Geusebroek2000). We search for the 
    
    polyOrder= 2;
    nPoints= 15;
    
  % Define extremes
    minPos= min(PosArray);
    maxPos= max(PosArray);
    finePosArray = linspace(minPos, maxPos, nPoints);
    
        
  % Fit data with a polynomial of order "polyOrder"  
    polyCoeff = polyfit(PosArray, sharpValArray, polyOrder);
    
  % Evaluate polynomial on finer grid between extremes
    yValues = polyval(polyCoeff, finePosArray);
  
  % Find maximum  
    [~, maxIndex]= max(yValues);
    finePosition= finePosArray(maxIndex);
    
%     disp('POS');
%     disp(PosArray);
%     disp('VAL');
%     disp(sharpValArray);
%     disp('finePos');
%     disp(finePosArray);
%     disp('yValue');
%     disp(yValues);
    
    fileID = fopen('D:\LSM_Data\OldFiles\150812_testFocus\myfile.txt','w');
    fprintf(fileID,'%s\t', 'Pos');
    for i=1: size(PosArray')
        fprintf(fileID,'%f\t', PosArray(i));
    end
    fprintf(fileID, '\n');
    
    fprintf(fileID,'%s\t', 'Val');
    for i=1: size(sharpValArray')
        fprintf(fileID,'%f\t', sharpValArray(i));
    end
    fprintf(fileID, '\n');
    
    fprintf(fileID,'%s\t', 'fineX');
    for i=1: size(finePosArray')
        fprintf(fileID,'%f\t', finePosArray(i));
    end
    fprintf(fileID, '\n');
    
    fprintf(fileID,'%s\t', 'yValues');
    for i=1: size(yValues')
        fprintf(fileID,'%f\t', yValues(i));
    end
    fprintf(fileID, '\n');
    fclose(fileID);
    
end

