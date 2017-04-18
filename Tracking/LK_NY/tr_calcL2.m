function [ L2 ] = tr_calcL2( I0, I1 )
 %% TR_CALCL2 Calculate the L2 value for two images
 %   For each pixel i calculate [I0(i) - I1(i)]^2 and sum over i
 %   Pixels with value 0 are not considered
 %   Two identical images will have L2= 0

    I0(~I0)= nan;
    I1(~I1)= nan;
    
    diffI= double(I1 - I0) .^2;
    I0norm= double(I0 ./ I0); % element is 1 only if original element was not 0
    I1norm= double(I1 ./ I1);
    
    
    diffI= diffI .* I0norm;
    diffI= diffI .* I1norm; % now diffI elements are ~=0 only if I0 and I1 elements also were ~=0
    
    B = reshape(diffI,[], 1);
    L2 = sum(B,1)./sum(B~=0,1);
    if (isnan(L2))
        L2=0;
    end
end

