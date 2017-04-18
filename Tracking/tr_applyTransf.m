function [ transfImg ] = tr_applyTransf( A, img)
%% Apply transformation to image
% Pixels not matched will be set to zero.

%http://www.mathworks.com/matlabcentral/answers/67114-what-is-the-difference-between-imwarp-and-imtransform


[width, height, depth]= size(img);

tform = affine3d(A); 
%tform = affine3d(A.'); % <==== NOTE THIS IS THE TRANSPOSE OF MATRIX!!!
RefIn = imref3d(size(img),[-width/2 width/2],[-height/2 height/2],[-depth/2 depth/2]);
RefOut= imref3d(size(img),[-width/2 width/2],[-height/2 height/2],[-depth/2 depth/2]);

%[transfImg, RJ] = imwarp(img, RefIn, tform, 'OutputView',RefOut);
[transfImg, RJ] = imwarp(img, RefIn, tform, 'OutputView',RefOut);
end
% 
% Rx = [1            0           0            0
%       0            cos(theta) -sin(theta)   0
%       0            sin(theta)  cos(theta)   0
%       0            0           0            1];
% 
% Ry = [cos(theta)   0           sin(theta)   0
%       0            1           0            0
%       -sin(theta)  0           cos(theta)   0
%       0            0           0            1];
%  
% Rz = [cos(theta)  -sin(theta)  0            0
%       sin(theta)   cos(theta)  0            0
%       0            0           1            0
%       0            0           0            1];
%   
% Rtrasla = [ 1            0           0            0
%             0            1           0            0
%             0            0           1            0
%             a            b           c            1];
% 
% a= move 2nd coord. Image shifts left-right
% b= move 1st coord. Image shifts up-down (positive move down).
% c= move 3rd coord. Move across stack.

% If I call X the horizontal axis (that matlab considers the 2nd index) 
% then Rx rotates along it, Ry rotates along the vertical one (1st index)
% and Rz rotates across the axiss which is orthogonal to the stack slices.
% 