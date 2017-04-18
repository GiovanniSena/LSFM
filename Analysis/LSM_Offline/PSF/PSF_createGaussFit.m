function [fitresult, gof] = PSF_createGaussFit( x, y, z, window )
%PSF_CREATEGAUSSFIT Summary of this function goes here
%   Detailed explanation goes here



%% Fit: 'Gauss2d'.
[xData, yData, zData] = prepareSurfaceData( x, y, z );

% Set up fittype and options.
ft = fittype( 'ped+a1*exp(-(x-x0)^2/(2*sigmax^2)-(y-y0)^2/(2*sigmay^2))', 'independent', {'x', 'y'}, 'dependent', 'z' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
% AMPLITUDE, PEDESTAL, SIGMAX, SIGMAY, XCENTER, YCENTER
opts.Lower = [0 0 0 0 1 1];
opts.StartPoint = [100 0 10 10 window/2 window/2];
opts.Upper = [Inf 15 Inf Inf window window];

% Fit model to data.
[fitresult, gof] = fit( [xData, yData], zData, ft, opts );
end

