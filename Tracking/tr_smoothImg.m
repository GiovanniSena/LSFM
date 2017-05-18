function [ smoothedImg ] = tr_smoothImg( originalImg, rad_x, rad_y, rad_z )
%%  TR_SMOOTHIMG Gaussian smooth filter
%   The smooth is performed using a Gauss filter with size:
%   [2*ceil(2*rad_x)+1} (and similarly for the y and z components).
%   Implemented with Matlab built-in functions.

%   Define kernel
    sigma= [rad_x, rad_y, rad_z];

%   Apply kernel to image
    myMsg= ('Smoothing image');
    disp(myMsg);
    smoothedImg = imgaussfilt3(originalImg, sigma, 'FilterSize', [2*ceil(2*rad_x)+1, 2*ceil(2*rad_y)+1, 1], 'Padding', 'replicate'); 
    myMsg= ('Smoothing done!');
    disp(myMsg);
end
