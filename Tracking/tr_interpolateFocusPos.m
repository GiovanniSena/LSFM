function [ finePosition ] = tr_interpolateFocusPos( PosArray, sharpValArray )
%%  TR_INTERPOLATEFOCUSPOS Given a vector of position and focus values, find the local maximum position
%   The focus measure can be modelled as a quadratic function around its
%   maximum (Geusebroek2000). We search for the position value where the maximum would reside.
%   The returned value "finePosition" should be located between the two
%   best focus points.
    
%   Fit parameters
    polyOrder= 2;
    nPoints= 15;
    
%   Define extremes of function
    minPos= min(PosArray);
    maxPos= max(PosArray);
    finePosArray = linspace(minPos, maxPos, nPoints);
            
%   Fit data with a polynomial of order "polyOrder"  
    polyCoeff = polyfit(PosArray, sharpValArray, polyOrder);
    
%   Evaluate polynomial on finer grid between extremes
    yValues = polyval(polyCoeff, finePosArray);
  
%   Find maximum  
    [~, maxIndex]= max(yValues);
    finePosition= finePosArray(maxIndex);
    
%   Write values to file for reference and check    
%     fileID = fopen('D:\LSM_Data\OldFiles\150812_testFocus\myfile.txt','w');
%     fprintf(fileID,'%s\t', 'Pos');
%     for i=1: size(PosArray')
%         fprintf(fileID,'%f\t', PosArray(i));
%     end
%     fprintf(fileID, '\n');
%     
%     fprintf(fileID,'%s\t', 'Val');
%     for i=1: size(sharpValArray')
%         fprintf(fileID,'%f\t', sharpValArray(i));
%     end
%     fprintf(fileID, '\n');
%     
%     fprintf(fileID,'%s\t', 'fineX');
%     for i=1: size(finePosArray')
%         fprintf(fileID,'%f\t', finePosArray(i));
%     end
%     fprintf(fileID, '\n');
%     
%     fprintf(fileID,'%s\t', 'yValues');
%     for i=1: size(yValues')
%         fprintf(fileID,'%f\t', yValues(i));
%     end
%     fprintf(fileID, '\n');
%     fclose(fileID);
end

