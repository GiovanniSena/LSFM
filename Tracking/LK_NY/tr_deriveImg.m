function [ outImg ] = tr_deriveImg( Img, n, direction )
%% Calculate the n-derivative of image: I(pixel) - I(pixel-1)
%   Direction can be 1 (x), 2 (y) or 3 (z)
%   Note that in imagej 1 corresponds to y, 2 to x

   outImg= diff(Img, n, direction);
   

end

