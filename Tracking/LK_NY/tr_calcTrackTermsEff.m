function [ sigma, tot ] = tr_calcTrackTerms( I0, I1, Rmatrix, R_dx, R_dy, R_dz, weightMatrix, sigma  )
 %% TR_CALCTRACKTERMS Summary of this function goes here
 %   Detailed explanation goes here

    [sizex, sizey, sizez]= size(I0);
    I0_dx= tr_deriveImg(I0, 1, 2);
    I1_dx= tr_deriveImg(I1, 1, 2);
    
    I0_dy= tr_deriveImg(I0, 1, 1);
    I1_dy= tr_deriveImg(I1, 1, 1);
    
    I0_dz= tr_deriveImg(I0, 1, 3);
    I1_dz= tr_deriveImg(I1, 1, 3);
    tic();
    for indexz= 2: sizez-2
        for indexy= 150: 550%sizey-2
            for indexx= 150: 550%sizex-2
                temp_v1(1)= I1_dx(indexx, indexy, indexz);
                temp_v1(2)= I1_dy(indexx, indexy, indexz);
                temp_v1(3)= I1_dz(indexx, indexy, indexz);
                temp_v1(4)= 0;
                
                temp_v2= double(temp_v1)*R_dx;
                temp_f1= indexx*temp_v2(1) + indexy*temp_v2(2) + indexz*temp_v2(3);
                
                temp_v2= double(temp_v1)*R_dy;
                temp_f2= indexx*temp_v2(1) + indexy*temp_v2(2) + indexz*temp_v2(3);
                
                temp_v2= double(temp_v1)*R_dz;
                temp_f3= indexx*temp_v2(1) + indexy*temp_v2(2) + indexz*temp_v2(3);
                
                sigma(1)= sigma(1) + temp_f1*temp_f1*weightMatrix(indexx, indexy, indexz);
                sigma(2)= sigma(2) + temp_f2*temp_f2*weightMatrix(indexx, indexy, indexz);
                sigma(3)= sigma(3) + temp_f3*temp_f3*weightMatrix(indexx, indexy, indexz);
                
                %sigma(4)= sigma(4) + I1_dx(indexx, indexy, indexz)*I1_dx(indexx, indexy, indexz)*weightMatrix(indexx, indexy, indexz);
                %sigma(5)= sigma(5) + I1_dy(indexx, indexy, indexz)*I1_dy(indexx, indexy, indexz)*weightMatrix(indexx, indexy, indexz);
                %sigma(6)= sigma(6) + I1_dz(indexx, indexy, indexz)*I1_dz(indexx, indexy, indexz)*weightMatrix(indexx, indexy, indexz);
                
                sigma(7)= sigma(7) + temp_f1*double((I1(indexx, indexy, indexz)-I0(indexx, indexy, indexz)))*weightMatrix(indexx, indexy, indexz);
                sigma(8)= sigma(8) + temp_f2*double((I1(indexx, indexy, indexz)-I0(indexx, indexy, indexz)))*weightMatrix(indexx, indexy, indexz);
                sigma(9)= sigma(9) + temp_f3*double((I1(indexx, indexy, indexz)-I0(indexx, indexy, indexz)))*weightMatrix(indexx, indexy, indexz);
                
                sigma(10)= sigma(10) + temp_f1*I1_dx(indexx, indexy, indexz)*weightMatrix(indexx, indexy, indexz);
                sigma(11)= sigma(11) + temp_f1*I1_dy(indexx, indexy, indexz)*weightMatrix(indexx, indexy, indexz);
                sigma(12)= sigma(12) + temp_f1*I1_dz(indexx, indexy, indexz)*weightMatrix(indexx, indexy, indexz);
                
                sigma(13)= sigma(13) + temp_f2*I1_dx(indexx, indexy, indexz)*weightMatrix(indexx, indexy, indexz);
                sigma(14)= sigma(14) + temp_f2*I1_dy(indexx, indexy, indexz)*weightMatrix(indexx, indexy, indexz);
                sigma(15)= sigma(15) + temp_f2*I1_dz(indexx, indexy, indexz)*weightMatrix(indexx, indexy, indexz);
                
                sigma(16)= sigma(16) + temp_f3*I1_dx(indexx, indexy, indexz)*weightMatrix(indexx, indexy, indexz);
                sigma(17)= sigma(17) + temp_f3*I1_dy(indexx, indexy, indexz)*weightMatrix(indexx, indexy, indexz);
                sigma(18)= sigma(18) + temp_f3*I1_dz(indexx, indexy, indexz)*weightMatrix(indexx, indexy, indexz);
                
                sigma(19)= sigma(19) + I1_dx(indexx, indexy, indexz)*double((I1(indexx, indexy, indexz)-I0(indexx, indexy, indexz)))*weightMatrix(indexx, indexy, indexz);
                sigma(20)= sigma(20) + I1_dy(indexx, indexy, indexz)*double((I1(indexx, indexy, indexz)-I0(indexx, indexy, indexz)))*weightMatrix(indexx, indexy, indexz);
                sigma(21)= sigma(21) + I1_dz(indexx, indexy, indexz)*double((I1(indexx, indexy, indexz)-I0(indexx, indexy, indexz)))*weightMatrix(indexx, indexy, indexz);
                
                sigma(22)= sigma(22) + temp_f1*temp_f2*weightMatrix(indexx, indexy, indexz);
                sigma(23)= sigma(23) + temp_f1*temp_f3*weightMatrix(indexx, indexy, indexz);
                sigma(24)= sigma(24) + temp_f2*temp_f3*weightMatrix(indexx, indexy, indexz);
                
                sigma(25)= sigma(25) + I1_dx(indexx, indexy, indexz)*I1_dy(indexx, indexy, indexz)*weightMatrix(indexx, indexy, indexz);
                sigma(26)= sigma(26) + I1_dx(indexx, indexy, indexz)*I1_dz(indexx, indexy, indexz)*weightMatrix(indexx, indexy, indexz);
                sigma(27)= sigma(27) + I1_dy(indexx, indexy, indexz)*I1_dz(indexx, indexy, indexz)*weightMatrix(indexx, indexy, indexz);
            end
        end
    end
    tot= sum(weightMatrix(:));
    
    sigma_4= I1_dx .* I1_dx .* weightMatrix;
    sigma(4)= sum(sigma_4(:));
    
    sigma_5= I1_dy .* I1_dy .* weightMatrix;
    sigma(5)= sum(sigma_4(:));
    
    sigma_6= I1_dz .* I1_dz .* weightMatrix;
    sigma(6)= sum(sigma_4(:));
    
    S(1,1) = sigma(1);
    S(1,2) = sigma(22);
    S(1,3) = sigma(23);
    S(1,4) = sigma(10);
    S(1,5) = sigma(11);
    S(1,6) = sigma(12);

    S(2,1) = sigma(22);
    S(2,2) = sigma(2);
    S(2,3) = sigma(24);
    S(2,4) = sigma(13);
    S(2,5) = sigma(14);
    S(2,6) = sigma(15);

    S(3,1) = sigma(23);
    S(3,2) = sigma(24);
    S(3,3) = sigma(3);
    S(3,4) = sigma(16);
    S(3,5) = sigma(17);
    S(3,6) = sigma(18);

    S(4,1) = sigma(10);
    S(4,2) = sigma(13);
    S(4,3) = sigma(16);
    S(4,4) = sigma(4);
    S(4,5) = sigma(25);
    S(4,6) = sigma(26);

    S(5,1) = sigma(11);
    S(5,2) = sigma(14);
    S(5,3) = sigma(17);
    S(5,4) = sigma(25);
    S(5,5) = sigma(5);
    S(5,6) = sigma(27);

    S(6,1) = sigma(12);
    S(6,2) = sigma(15);
    S(6,3) = sigma(18);
    S(6,4) = sigma(26);
    S(6,5) = sigma(27);
    S(6,6) = sigma(6);

    b(1,1) = -sigma(7);
    b(2,1) = -sigma(8);
    b(3,1) = -sigma(9);
    b(4,1) = -sigma(19);
    b(5,1) = -sigma(20);
    b(6,1) = -sigma(21);
    
    myX = mldivide(S,b);
    toc()
end

