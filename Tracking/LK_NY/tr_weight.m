function [ weightMatrix ] = tr_weight( I0, I1, L )
 %% TR_WEIGHT Returns a map with weight for each pixel
 %  The weight for each pixel i is calculated as follows:
 %  L / (L + pow(dxI2[p] - dxI1[p], 2.0) + pow(dyI2[p] - dyI1[p], 2.0) + pow(dzI2[p] - dzI1[p], 2.0));
    
 % calculate first derivative of I0 and I1 in x, y, z direction
    I0_dx= tr_deriveImg(I0, 1, 2);
    I1_dx= tr_deriveImg(I1, 1, 2);
    
    I0_dy= tr_deriveImg(I0, 1, 1);
    I1_dy= tr_deriveImg(I1, 1, 1);
    
    I0_dz= tr_deriveImg(I0, 1, 3);
    I1_dz= tr_deriveImg(I1, 1, 3);
  
 % calculate pixel-by-pixel difference
    delta_dx= double(I0_dx) - double(I1_dx);
    delta_dy= double(I0_dy) - double(I1_dy);
    delta_dz= double(I0_dz) - double(I1_dz);
 
 % calculate square of difference
    delta_dx2= delta_dx .^2;
    delta_dy2= delta_dy .^2;
    delta_dz2= delta_dz .^2;
 
 % resize squares to leave out last pixel in each direction (derivative do not exist there)   
    [ylimit, xlimit, zlimit]= size(delta_dx2);
    ylimit= ylimit-1;
    zlimit= zlimit-1;
 
    delta_dx2= delta_dx2(1:ylimit, 1:xlimit, 1:zlimit);
    delta_dy2= delta_dy2(1:ylimit, 1:xlimit, 1:zlimit);
    delta_dz2= delta_dz2(1:ylimit, 1:xlimit, 1:zlimit);
 
 % calculate weigth matrix
    weightMatrix= (delta_dx2 + delta_dy2 + delta_dz2) + L;
    
    weightMatrix= L./weightMatrix;
    
   
    
end

