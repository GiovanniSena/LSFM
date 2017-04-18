function [ output_args ] = PSF_printFitResults( fileID, fitResults )
%PSF_PRINTFITRESULTS Summary of this function goes here
%   Detailed explanation goes here


    
    %fitResults
    cNames= coeffnames( fitResults);
    cValues= coeffvalues( fitResults);
    [nCoeff,~]=size(cNames);
    for iCoeff= 1: nCoeff
        fprintf(fileID, '%s = %f\n', char(cNames(iCoeff)), cValues(iCoeff));
    end
    fprintf(fileID, '======================\n');


end

