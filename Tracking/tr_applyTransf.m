function [ transfImg ] = tr_applyTransf( A, img)
%%  TR_APPLYTRANSF Apply transformation to image
%   Give a 4x4 transformation matrix A and a NxMxP stack of images, the function
%   applies the transformation and returns the resulting
%   stack.
%   The function uses a system of reference centered in the middle of the stack to ensure that
%   the transformation is performed correctly.
%   Pixels not matched will be set to zero.
%   See Mathworks documentation regarding imref3d and imwarp.


%   Get image size
    [width, height, depth]= size(img);

%   Define tform from transformation matrix
    tform = affine3d(A); 
    RefIn = imref3d(size(img),[-width/2 width/2],[-height/2 height/2],[-depth/2 depth/2]);
    RefOut= imref3d(size(img),[-width/2 width/2],[-height/2 height/2],[-depth/2 depth/2]);
    
%   Apply transformation
    [transfImg, RJ] = imwarp(img, RefIn, tform, 'OutputView',RefOut);
end


% Note: A brief reminder of how to define the transformation matrix

%   ROTATIONS
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
%   RIGID TRANSLATION
% Rtrasla = [ 1            0           0            0
%             0            1           0            0
%             0            0           1            0
%             a            b           c            1];
% 
% a= move 2nd coord. Image shifts left-right
% b= move 1st coord. Image shifts up-down (positive move down).
% c= move 3rd coord. Move across stack.

% Defining X the horizontal axis (that matlab considers the 2nd index) 
% then Rx rotates along it, Ry rotates along the vertical one (1st index)
% and Rz rotates across the axiss which is orthogonal to the stack slices.
