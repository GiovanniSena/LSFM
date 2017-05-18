function [ traslatedStack ] = tr_transformCurrentStack( curStack, best_A, RA )
%%  TR_TRANSFORMCURRENTSTACK Calculates how the current image should look after the transformation matrix is applied to it
%   After we determine the translation required, we move the motors but we
%   do not take another scan. We estimate what the stack in the new
%   position would look like by using this function.
%   The transformation matrix if modified to remove any rotation and
%   applied to the stack. The transformed stack is returned.
 
%   REMOVE ROTATION TERMS FROM MATRIX
    best_A(1,1)= 1;
    best_A(1,2)= 0;
    best_A(1,3)= 0;
    best_A(2,1)= 0;
    best_A(2,2)= 1;
    best_A(2,3)= 0;
    best_A(3,1)= 0;
    best_A(3,2)= 0;
    best_A(3,3)= 1;
    
%   INVERT TRANSLATION (TO APPLY IT TO LATEST STACK) 
    best_A(4,1)= -best_A(4,1);
    best_A(4,2)= -best_A(4,2);
    best_A(4,3)= -best_A(4,3);
  
%   APPLY TRANSLATION TO STACK  
    traslatedStack= tr_applyTransfRef(best_A, curStack, RA, RA);
end

