function [ Rmatrix, R_dtx, R_dty, R_dtz ] = tr_Rmatrix( theta, displace )
 %% TR_RMATRIX Returns R matrix and its derivatives
 %  Rmatrix is the transformation matrix, obtained using the angles in
 %  theta (thetax, thetay, thetaz) and the displacement
 %  R_dtx is the first derivative with respect to angle theta x
 %  R_dty is the first derivative with respect to angle theta y
 %  R_dtz is the first derivative with respect to angle theta z
 
    Rmatrix = [ 1            0           0            0
                0            1           0            0
                0            0           1            0
                0            0           0            1];
    
    Rmatrix(1,1)=  cos(theta(2))*cos(theta(3));     
    Rmatrix(1,2)=  cos(theta(1))*sin(theta(3)) + sin(theta(1))*sin(theta(2))*cos(theta(3));
    Rmatrix(1,3)=  sin(theta(1))*sin(theta(3)) - cos(theta(1))*sin(theta(2))*cos(theta(3));
    
    Rmatrix(2,1)= -cos(theta(2))*sin(theta(3));
    Rmatrix(2,2)=  cos(theta(1))*cos(theta(3)) - sin(theta(1))*sin(theta(2))*sin(theta(3));
    Rmatrix(2,3)=  sin(theta(1))*cos(theta(3)) + cos(theta(1))*sin(theta(2))*sin(theta(3));
    
    Rmatrix(3,1)=  sin(theta(2));
    Rmatrix(3,2)= -sin(theta(1))*cos(theta(2));
    Rmatrix(3,3)=  cos(theta(1))*cos(theta(2));
    
    Rmatrix(4,1)= displace(1);
    Rmatrix(4,2)= displace(2);
    Rmatrix(4,3)= displace(3);
    
 %==dR/dthetaX===================================
    R_dtx(1, 1)=  0;
    R_dtx(1, 2)= -sin(theta(1))*sin(theta(3)) + cos(theta(1))*sin(theta(2))*cos(theta(3));
    R_dtx(1, 3)=  cos(theta(1))*sin(theta(3)) + sin(theta(1))*sin(theta(2))*cos(theta(3));
    R_dtx(1, 4)=  0;
    
    R_dtx(2, 1)=  0;
    R_dtx(2, 2)= -sin(theta(1))*cos(theta(3)) - cos(theta(1))*sin(theta(2))*sin(theta(3));
    R_dtx(2, 3)=  cos(theta(1))*cos(theta(3)) - sin(theta(1))*sin(theta(2))*sin(theta(3));
    R_dtx(2, 4)=  0;
    
    R_dtx(3, 1)=  0;
    R_dtx(3, 2)= -cos(theta(1))*cos(theta(2));
    R_dtx(3, 3)= -sin(theta(1))*cos(theta(2));
    R_dtx(3, 4)=  0;
    
    R_dtx(4, 1)=  0;
    R_dtx(4, 2)=  0;
    R_dtx(4, 3)=  0;
    R_dtx(4, 4)=  1; % <-- ?
    
 %==dR/dthetaY===================================
    R_dty(1, 1)= -sin(theta(2))*cos(theta(3));
    R_dty(1, 2)=  sin(theta(1))*cos(theta(2))*cos(theta(3));
    R_dty(1, 3)= -cos(theta(1))*cos(theta(2))*cos(theta(3));
    R_dty(1, 4)=  0;
    
    R_dty(2, 1)=  sin(theta(2))*sin(theta(3));
    R_dty(2, 2)= -sin(theta(1))*cos(theta(2))*sin(theta(3));
    R_dty(2, 3)=  cos(theta(1))*cos(theta(2))*sin(theta(3));
    R_dty(2, 4)=  0;
    
    R_dty(3, 1)=  cos(theta(2));
    R_dty(3, 2)=  sin(theta(1))*sin(theta(2));
    R_dty(3, 3)= -cos(theta(1))*sin(theta(2));
    R_dty(3, 4)=  0;
    
    R_dty(4, 1)=  0;
    R_dty(4, 2)=  0;
    R_dty(4, 3)=  0;
    R_dty(4, 4)=  1; % <-- ?
    
 %==dR/dthetaZ===================================
    R_dtz(1, 1)= -cos(theta(2))*sin(theta(3));
    R_dtz(1, 2)=  cos(theta(1))*cos(theta(3)) - sin(theta(1))*sin(theta(2))*sin(theta(3));
    R_dtz(1, 3)=  sin(theta(1))*cos(theta(3)) + cos(theta(1))*sin(theta(2))*sin(theta(3));
    R_dtz(1, 4)=  0;
    
    R_dtz(2, 1)= -cos(theta(2))*cos(theta(3));
    R_dtz(2, 2)= -cos(theta(1))*sin(theta(3)) - sin(theta(1))*sin(theta(2))*cos(theta(3));
    R_dtz(2, 3)= -sin(theta(1))*sin(theta(3)) + cos(theta(1))*sin(theta(2))*cos(theta(3));
    R_dtz(2, 4)=  0;
    
    R_dtz(3, 1)=  0;
    R_dtz(3, 2)=  0;
    R_dtz(3, 3)=  0;
    R_dtz(3, 4)=  0;
    
    R_dtz(4, 1)=  0;
    R_dtz(4, 2)=  0;
    R_dtz(4, 3)=  0;
    R_dtz(4, 4)=  1;
    
end

