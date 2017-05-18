function [ stackName ] = tr_createStackName( runNumber, acquiredTp )
%%  TR_CREATEFILENAME Returns a name to be used for the image stack
%   This function simply returns a string corresponding to the name that
%   will be used to save a stack of images. The output string has the
%   following format:
%   RunXXXX_yymmdd_hhMM.tif
%   where: XXXX is the integer 'runNumber' zero padded, yymmdd is the
%   current date (for example 150901 is September 1st 2015) and hhMM is the
%   current time in 24h format (for instance 1711 corresponds to 5:11
%   p.m.).
%   The file name will be unique AS LONG AS THE USER CHOOSES A DIFFERENT
%   runNumber OR THE FUNCTION IS NOT RUN TWICE WITHIN THE SAME MINUTE
%   After GS's request (20/06/2016) the file are now named
%   RunXXXX_tpYYY.tif where XXXX is the Run number and tp is the
%   consecutive stack (time point) for that run.
 
 
    %formatOut = 'yymmdd_hhMM';
    %dateString= datestr(now,formatOut);
    %stackName= sprintf('Run%04d_%s.tif', runNumber, dateString);
    
    stackName= sprintf('Run%04d_tp%03d.tif', runNumber, acquiredTp);
end

