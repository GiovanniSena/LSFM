function [ smoothedImg ] = smoothImg( originalImg, rad_x, rad_y, rad_z )
%% Gaussian smooth filter.
% In the original code, apply a gaussian filter to a kernel with size defined by rad_x, rad_y and rad_z.
% Here implemented with Matlab built-in functions to save time.

    sigma= [rad_x, rad_y, rad_z];
    
    smoothedImg = imgaussfilt3(originalImg, sigma, 'FilterSize', [2*ceil(2*rad_x)+1, 2*ceil(2*rad_y)+1, 1], 'Padding', 'replicate'); 


end
