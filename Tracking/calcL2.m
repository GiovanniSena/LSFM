function [ L2 ] = calcL2(i1, i2, x1, x2, y1, y2, z1, z2)
%% Pixel by pixel comparison
% If two images are identical return 0. Larger values indicate large
% difference in images.
% Differs from the C++ code in the fact that we sum over all pixels pairs, not
% just those for which I1(x, y, k) and I2(x, y, k) are not zero.
% Also, at the moment the ROI is not implemented and the loop is performed
% over the whole stack.

	C= double(i1-i2);
    D= C.*C;
    L2 = sum(D(:));
    L2 = sqrt(L2/numel(C(:)));
    text= ['L2= ' num2str(L2)];
    disp(text);
	
end