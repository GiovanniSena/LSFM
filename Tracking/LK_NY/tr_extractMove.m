function [ theta, displace ] = tr_extractMove( R_matrix )
%% TR_EXTRACTMOVE Calculates angles theta and displacement from the R_matrix
%   
    theta(1)= atan2( -R_matrix(3,2), R_matrix(3,3) );
    theta(2)= atan2(  R_matrix(3,1), sqrt( power(R_matrix(3,2), 2) + power(R_matrix(3,3), 2)));
    theta(3)= atan2( -R_matrix(2,1), R_matrix(1,1));
    
    displace(1)= R_matrix(4, 1);
    displace(2)= R_matrix(4, 2);
    displace(3)= R_matrix(4, 3);

end

