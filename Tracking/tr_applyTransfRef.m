function [ transfImg ] = tr_applyTransfRef( A, img, RefIn, RefOut)
%%  TR_APPLYTRANSFREF Apply transformation to image
%   Give a 4x4 transformation matrix A and a NxMxP stack of images, the function
%   applies the transformation and returns the resulting
%   stack.
%   The function uses a system of reference centered in the middle of the stack to ensure that
%   the transformation is performed correctly.
%   Pixels not matched will be set to zero.
%   See Mathworks documentation regarding imref3d and imwarp.
%   NOTE: This function differs from TR_APPLYTRANSF in the fact that the
%   coordinated references must be provided by the user instead of
%   inferring them from the input stack.

%   Get image size
    [width, height, depth]= size(img);

%   Define tform from transformation matrix
    tform = affine3d(A); 
    myMsg= [];

%   Apply transformation
    [transfImg, RJ] = imwarp(img, RefIn, tform, 'OutputView', RefOut);
end
