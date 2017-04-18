function [ best_A ] = findTransfMatlab( prevStack, curStack, scale0, scale1, scaleMult, nIterations, z_over_x, L )
%% 
%

    I1 = prevStack;
    I2 = curStack;
 % INITIAL PARAMETERS MINE
    [imgW, imgH, imgD] = size(curStack);
    %imgW = 1040;
    %imgH = 1392;
    %imgD = 16;
    
    ROI_x1 = 1;
    ROI_x2 = imgW;
    ROI_y1 = 1; 
    ROI_y2 = imgH;
    TRACK_X = (ROI_x1+ROI_x2)/2;
    TRACK_Y = (ROI_y1+ROI_y2)/2;
    
    theta = zeros(1, 3);
    S = zeros(6);
    b= zeros(1, 6);
    
    temp_v1 = zeros(1, 4);
	temp_v2 = zeros(1, 4);

    %xI2 = zeros(imgW, imgH, imgD, 'uint16');
	%rI1 = zeros(imgW, imgH, imgD, 'uint16');
	%rI2 = zeros(imgW, imgH, imgD, 'uint16');
    
 	%A = zeros(4);
	dA = zeros(4);
	dxA = zeros(4);
	dyA = zeros(4);
	dzA = zeros(4);
	temp_mat = zeros(4);

    best_A = eye(4); % IDENTITY 4x4
    
    %for scale_xy = scale0; scale_xy >= scale1; scale_xy *= scaleMult
    scale_xy = scale0;
    while (scale_xy >= scale1)
        scale_xy = scale_xy * scaleMult;
        szStr=['Start tracking at scale_xy= :' num2str(scale_xy)];
        disp(szStr)
        %fflush(trackLogFile);
        best_L2 = realmax;
        A= best_A;
        theta(1) = atan2(-A(2,3), A(3,3));
        theta(2) = atan2( A(1,3), sqrt( power(A(2,3),2) + power(A(3,3),2) ) );
        theta(3) = atan2(-A(1,2), A(1, 1)); 
		
        scale_z = z_over_x * scale_xy;
        if (scale_z < 1.0) 
            scale_z = 1.0;
        end
        
        szStr=['Resizing I1 (scale_xy: ' num2str(scale_xy) ' scale_z: ' num2str(scale_z) ')'];
        disp(szStr)
        %fflush(trackLogFile);
        rI1 = resizeStack(I1, scale_xy, scale_z);
		
        szStr=['Resizing I2 (scale_xy: ' num2str(scale_xy) ' scale_z: ' num2str(scale_z) ')'];
        disp(szStr)
		%fflush(trackLogFile);
		rI2 = resizeStack(I2, scale_xy, scale_z);
        
		disp('Done resizing');
		%fflush(trackLogFile);
        
        if (isempty(rI1)) 
            disp('rI1 is empty');
			%fprintf(trackLogFile, "rI1->pix is null!\n");
			%fflush(trackLogFile);
			break;
        end
        
        if (isempty(rI2)) 
            disp('rI1 is empty');
			%fprintf(trackLogFile, "rI2->pix is null!\n");
			%fflush(trackLogFile);
			break;
        end
        
        disp('Smooth rI1');
        %fprintf(trackLogFile, "Smoothing rI1\n");
		%fflush(trackLogFile);
		rI1 = tr_smoothImg(rI1, 2, 2, 1);
        
        disp('Smooth rI2');
		%fprintf(trackLogFile, "Smoothing rI2\n");
		%fflush(trackLogFile);
		rI2 = tr_smoothImg(rI2, 2, 2, 1);
        
        disp('Done smoothing');
		%fprintf(trackLogFile, "Done smoothing\n");
		%fflush(trackLogFile);
        
        [rw, rh, rdepth] = size(rI2);
        %rwh = rw*rh;
        
        x1 = round((ROI_x1/scale_xy)+1);
		x2 = round((ROI_x2/scale_xy)-1);
		y1 = round((ROI_y1/scale_xy)+1);
		y2 = round((ROI_y2/scale_xy)-1);
		z1 = 1;
		z2 = rdepth;
        
        xo = -TRACK_X/scale_xy;
		yo = -TRACK_Y/scale_xy;
		zo = -0.5*rdepth;
		
        %xI2 =  zeros(rw, rh, rdepth);        
		dxI1 = zeros(rw, rh, rdepth);
		dyI1 = zeros(rw, rh, rdepth);
		dzI1 = zeros(rw, rh, rdepth);
		dxI2 = zeros(rw, rh, rdepth);
		dyI2 = zeros(rw, rh, rdepth);
		dzI2 = zeros(rw, rh, rdepth);
		weight = zeros(rw, rh, rdepth);
        
        for iter = 0: nIterations
            
            szStr=['Start iteration ' num2str(iter) ];
            disp(szStr)
			%fprintf(trackLogFile, "\tStarting iteration %d\n", iter);
			%fflush(trackLogFile);
			cosx = cos(theta(1));
			cosy = cos(theta(2));
			cosz = cos(theta(3));
			sinx = sin(theta(1));
			siny = sin(theta(2));
			sinz = sin(theta(3));
            
            % initialize the derivatives of A from theta calculated previously:
			dxA(1,1) = 0.0;
			dxA(1,2) = 0.0;
			dxA(1,3) = 0.0;
			dxA(1,4) = 0.0;

			dxA(2,1) = cosx*siny*cosz-sinx*sinz;
			dxA(2,2) = -cosx*siny*sinz-sinx*cosz;
			dxA(2,3) = -cosx*cosy;
			dxA(2,4) = 0.0;

            dxA(3,1) = sinx*siny*cosz+cosx*sinz;
			dxA(3,2) = -sinx*siny*sinz+cosx*cosz;
			dxA(3,3) = -sinx*cosy;
			dxA(3,4) = 0.0;

			dxA(4,1) = 0.0;
			dxA(4,2) = 0.0;
			dxA(4,3) = 0.0;
			dxA(4,4) = 1.0;

			dyA(1,1) = -siny*cosz;
			dyA(1,2) = siny*sinz;
			dyA(1,3) = cosy;
			dyA(1,4) = 0.0;

			dyA(2,1) = sinx*cosy*cosz;
			dyA(2,2) = -sinx*cosy*sinz;
			dyA(2,3) = sinx*siny;
			dyA(2,4) = 0.0;

			dyA(3,1) = -cosx*cosy*cosz;
			dyA(3,2) = cosx*cosy*sinz;
			dyA(3,3) = -cosx*siny;
			dyA(3,4) = 0.0;

			dyA(4,1) = 0.0;
			dyA(4,2) = 0.0;
			dyA(4,3) = 0.0;
			dyA(4,4) = 1.0;

			dzA(1,1) = -cosy*sinz;
			dzA(1,2) = -cosy*cosz;
			dzA(1,3) = 0.0;
			dzA(1,4) = 0.0;

			dzA(2,1) = -sinx*siny*sinz+cosx*cosz;
			dzA(2,2) = -sinx*siny*cosz-cosx*sinz;
			dzA(2,3) = 0.0;
			dzA(2,4) = 0.0;

			dzA(3,1) = cosx*siny*sinz+sinx*cosz;
			dzA(3,2) = cosx*siny*cosz-sinx*sinz;
			dzA(3,3) = 0.0;
			dzA(3,4) = 0.0;

			dzA(4,1) = 0.0;
			dzA(4,2) = 0.0;
			dzA(4,3) = 0.0;
			dzA(4,4) = 1.0;
            
            A(4,1) = A(4,1)/scale_xy;
			A(4,2) = A(4,2)/scale_xy;
			A(4,3) = A(4,3)/scale_z;
			A(4,4) = 1.0;

			%fprintf(trackLogFile, "\tApplying transformation:\n");
            disp('Apply transformation');
% 			for (i = 0; i < 4; i++) {
% 				for (j = 0; j < 4; j++) {
% 					fprintf(trackLogFile, "\t%f", A[i][j]);
% 				}
% 				fprintf(trackLogFile, "\n");
% 			}
			%fflush(trackLogFile);
            xI2 = applyTransf( A, rI2);
            disp('Done transformation');
			%fprintf(trackLogFile, "\tDone applying transformation\n");
			%fflush(trackLogFile);
			A(4,1)= A(4,1)*scale_xy;
			A(4,2)= A(4,2)*scale_xy;
			A(4,3)= A(4,3)*scale_z;
			A(4,4)= 1.0;

            szStr=['Calculating L2'];
            disp(szStr);
            %fprintf(trackLogFile, "\tCalculating L2\n");
			%fflush(trackLogFile);
			L2 = calcL2(rI1, xI2, ROI_x1/scale_xy, ROI_x2/scale_xy, ROI_y1/scale_xy, ROI_y2/scale_xy, 0, rdepth);
            if (L2 < best_L2)
				best_L2 = L2;
				best_A = A;
            end
            disp('L2 calculated');
			%fprintf(trackLogFile, "\tDone calculating L2\n");
			%fflush(trackLogFile);
			mySigma= zeros(27, 1);
			
            disp('Calculating tracking terms');
			%fprintf(trackLogFile, "\tCalculating tracking terms\n");
			%fflush(trackLogFile);
			tot = 0.0;
            
            
            img_ROI=  tr_extractROI(I1
 %Now loop over all element of matrixes
            xx= xo;
            yy= yo;
            zz= zo;
            for idx = 1:numel(I1)
                
                [px, py, pz] = ind2sub(I1, idx);
                xx= xx + px;
                yy= yy + py;
                zz= zz + pz;
                
                dxI1(idx) = double(rI1(px+1, py, pz) - rI1(px, py, pz)); 
                dyI1(idx) = double(rI1(px, py+1, pz) - rI1(px, py, pz)); 
                dzI1(idx) = double(rI1(px, py, pz+1) - rI1(px, py, pz)); 
                
                dxI2(idx) = double(xI2(px+1, py, pz) - xI2(px, py, pz)); 
                dyI2(idx) = double(xI2(px, py+1, pz) - xI2(px, py, pz)); 
                dzI2(idx) = double(xI2(px, py, pz+1) - xI2(px, py, pz)); 
                
                if ( (xI2(px, py, pz) == 0) || (xI2(px+1, py, pz) == 0) || (xI2(px, py+1, pz) == 0) || (xI2(px, py, pz+1) == 0) )
                    weight(idx) = 0.0;
                elseif ( (rI2(px, py, pz) == 0) || (rI2(px+1, py, pz) == 0) || (rI2(px, py+1, pz) == 0) || (rI2(px, py, pz+1) == 0) )
                    weight(idx) = 0.0;
                else
                    weight(idx) = L / (L + power(dxI2(idx) - dxI1(idx), 2.0) + pow(dyI2(idx) - dyI1(idx), 2.0) + pow(dzI2(idx) - dzI1(idx), 2.0));		                
                end
                temp_v1 = [dxI2(idx), dyI2(idx), dzI2(idx), 0];
                temp_v2 = dxA*temp_v1;
                temp_f1 = xx*temp_v2(1) + yy*temp_v2(2) + zz*temp_v2(3);
                
                temp_v2 = dyA*temp_v1;
                temp_f2 = xx*temp_v2(1) + yy*temp_v2(2) + zz*temp_v2(3);
						
				temp_v2 = dzA*temp_v1;
                temp_f3 = xx*temp_v2(1) + yy*temp_v2(2) + zz*temp_v2(3);
                
                mySigma(1) = mySigma(1) + temp_f1*temp_f1*weight(idx);
                mySigma(2) = mySigma(2) + temp_f2*temp_f2*weight(idx);
                mySigma(3) = mySigma(3) + temp_f3*temp_f3*weight(idx);
                
                mySigma(4) = mySigma(4)+ dxI2(idx)*dxI2(idx)*weight(idx);
                mySigma(5) = mySigma(5)+ dyI2(idx)*dyI2(idx)*weight(idx);
                mySigma(6) = mySigma(6)+ dzI2(idx)*dzI2(idx)*weight(idx);
                
                mySigma(7) = mySigma(7)+ temp_f1 * (xI2(idx) - rI1(idx))*weight(idx);
                mySigma(8) = mySigma(8)+ temp_f2 * (xI2(idx) - rI1(idx))*weight(idx);
                mySigma(9) = mySigma(9)+ temp_f3 * (xI2(idx) - rI1(idx))*weight(idx);
                
                mySigma(10) = mySigma(10) + temp_f1*dxI2(idx)*weight(idx);
                mySigma(11) = mySigma(11) + temp_f1*dyI2(idx)*weight(idx);
                mySigma(12) = mySigma(12) + temp_f1*dzI2(idx)*weight(idx);
                
                mySigma(13) = mySigma(13) + temp_f2*dxI2(idx)*weight(idx);
                mySigma(14) = mySigma(14) + temp_f2*dyI2(idx)*weight(idx);
                mySigma(15) = mySigma(15) + temp_f2*dzI2(idx)*weight(idx);
				
                mySigma(16) = mySigma(16) + temp_f3*dxI2(idx)*weight(idx);
                mySigma(17) = mySigma(17) + temp_f3*dyI2(idx)*weight(idx);
                mySigma(18) = mySigma(18) + temp_f3*dzI2(idx)*weight(idx);
				
                mySigma(19) = mySigma(19) + dxI2(idx)*(xI2(idx) - rI2(idx))*weight(idx);
                mySigma(20) = mySigma(20) + dyI2(idx)*(xI2(idx) - rI2(idx))*weight(idx);
                mySigma(21) = mySigma(21) + dzI2(idx)*(xI2(idx) - rI2(idx))*weight(idx);
				
                mySigma(22) = mySigma(22) + temp_f1*temp_f2*weight(idx);
                mySigma(23) = mySigma(23) + temp_f1*temp_f3*weight(idx);
                mySigma(24) = mySigma(24) + temp_f2*temp_f3*weight(idx);
                
                mySigma(25) = mySigma(25) + dxI2(idx)*dyI2(idx)*weight(idx);
                mySigma(26) = mySigma(26) + dxI2(idx)*dzI2(idx)*weight(idx);
                mySigma(27) = mySigma(27) + dyI2(idx)*dzI2(idx)*weight(idx);
				tot = tot + weight(idx);
            end
            disp('Tracking terms calculated');
            %fprintf(trackLogFile, "\tDone calculating tracking terms\n");
			%fflush(trackLogFile);
            zero_overlap_flag = 'false';
            if (tot < 1.0) 
            % //it is possible that zero overlap is caused by the way
            % //zero pixels at the border are propagated to the scaled, smoothed
            % //images, especially at large scales.  So unless this is the smallest scale,
            % //just skip to the next scale
                szStr=['Zero overlap at iteration ' num2str(iter) ' scale_xy: ' num2str(scale_xy) ')'];
                disp(szStr)
		
				%fprintf(trackLogFile, "Zero overlap at iteration %d, scale_xy %f, best_A:\n", iter, scale_xy);
                %for i = 1:4 
                    %for j = 1:4
                        %fprintf(trackLogFile, "%f\t", best_A[i][j]);
                    %end
                    %fprintf(trackLogFile, "\n");
                %end
				%fflush(trackLogFile);
				zero_overlap_flag = 'true';
				break;
            end
            S(1,1) = mySigma(1);
			S(1,2) = mySigma(22);
			S(1,3) = mySigma(23);
			S(1,4) = mySigma(10);
			S(1,5) = mySigma(11);
			S(1,6) = mySigma(12);
            
            S(2,1) = mySigma(22);
			S(2,2) = mySigma(2);
			S(2,3) = mySigma(24);
			S(2,4) = mySigma(13);
			S(2,5) = mySigma(14);
			S(2,6) = mySigma(15);

			S(3,1) = mySigma(23);
			S(3,2) = mySigma(24);
			S(3,3) = mySigma(3);
			S(3,4) = mySigma(16);
			S(3,5) = mySigma(17);
			S(3,6) = mySigma(18);

			S(4,1) = mySigma(10);
			S(4,2) = mySigma(13);
			S(4,3) = mySigma(16);
			S(4,4) = mySigma(4);
			S(4,5) = mySigma(25);
			S(4,6) = mySigma(26);

			S(5,1) = mySigma(11);
			S(5,2) = mySigma(14);
			S(5,3) = mySigma(17);
			S(5,4) = mySigma(25);
			S(5,5) = mySigma(5);
			S(5,6) = mySigma(27);

			S(6,1) = mySigma(12);
			S(6,2) = mySigma(15);
			S(6,3) = mySigma(18);
			S(6,4) = mySigma(26);
			S(6,5) = mySigma(27);
			S(6,6) = mySigma(6);
            
            b(1) = -mySigma(7);
			b(2) = -mySigma(8);
			b(3) = -mySigma(9);
			b(4) = -mySigma(19);
			b(5) = -mySigma(20);
			b(6) = -mySigma(21);
            
            disp('Inverting matrix');
            %fprintf(trackLogFile, "\tInverting tracking matrix\n");
			%fflush(trackLogFile);
			%gaussj(S, b); %                         <===== NEED TO DOUBLE CHECK THIS
            S = S\b;                                 %<=====THIS IS WRONG. I NEED TO FIND b
            disp('Matrix inversion done');
			%fprintf(trackLogFile, "\tDone inverting tracking matrix\n");
			%fflush(trackLogFile);
            
            cosx = cos(b(1));
			cosy = cos(b(2));
			cosz = cos(b(3));
			sinx = sin(b(1));
			siny = sin(b(2));
			sinz = sin(b(3));

			dA(1,1) = cosy*cosz;
			dA(1,2) = -cosy*sinz;
			dA(1,3) = siny;
			dA(1,4) = 0.0;

			dA(2,1) = sinx*siny*cosz + cosx*sinz;
			dA(2,2) = cosx*cosz-sinx*siny*sinz;
			dA(2,3) = -sinx*cosy;
			dA(2,4) = 0.0;

			dA(3,1) = -cosx*siny*cosz + sinx*sinz;
			dA(3,2) = cosx*siny*sinz + sinx*cosz;
			dA(3,3)= cosx*cosy;
			dA(3,4) = 0.0;

			dA(4,1) = b(4)*scale_xy;
			dA(4,2) = b(5)*scale_xy;
			dA(4,3) = b(6)*scale_z;
			dA(4,4) = 1.0;
            
            disp('Calculating temp_Mat');
			%fprintf(trackLogFile, "\tCalculating temp_mat\n");
			%fflush(trackLogFile);
            
            matMult(A, dA, temp_mat);
            temp_Mat = A*dA;
            
            
			%fprintf(trackLogFile, "\tDone with matrix multiplication\n");
			%fflush(trackLogFile);
            A = temp_Mat;
            
			disp('temp_Mat calculated');
			%fprintf(trackLogFile, "\tDone calculating temp_mat\n");
			%fflush(trackLogFile);
            
            %//calculate angles from A:
			theta(1) = atan2(-A(2,3), A(3,3));
			theta(2) = atan2(A(1,3) , sqrt(power(A(2,3), 2.0) + power(A(3,3), 2.0)));
			theta(3) = atan2(-A(1,2), A(1,1));
			
            szStr=[num2str(scale_xy) '\t' num2str(scale_z) '\t' num2str(iter) '\t' num2str(tot)];
            disp(szStr);
		
			%fprintf(trackFile, "%f\t%f\t%d\t%f\t", scale_xy, scale_z, iter, tot);
% 			for (i = 0; i < 27; i++)
% 				fprintf(trackFile, "%f\t", sigma[i]);
%             end
% 			for (i = 0; i < 6; i++)
% 				fprintf(trackFile, "%f\t", b[i]);
%             end
% 			for (i = 0; i < 3; i++)
% 				fprintf(trackFile, "%f\t", theta[i]);
%             end
			temp_v1(1) = 0.0;
			temp_v1(2) = 0.0;
			temp_v1(3) = 0.0;
			temp_v1(4) = 1.0;
            
            disp('Calculating temp_v2');
			%fprintf(trackLogFile, "\tCalculating temp_v2\n");
			%fflush(trackLogFile);
			vectMatMult(temp_v1, A, temp_v2);
            temp_v2 = temp_v1*A;
% 			for (i = 0; i < 3; i++)
% 				fprintf(trackFile, "%f\t", temp_v2[i]-temp_v1[i]);
%             end
			%fprintf(trackFile, "%f\n", L2);
			%fflush(trackFile);
			%fprintf(trackLogFile, "\tDone calculating temp_v2\n");
			%fflush(trackLogFile);
        end
%             fprintf(trackLogFile, "Freeing dxI1\n");
%             fflush(trackLogFile);
            delete 'dxI1';
%             fprintf(trackLogFile, "Freeing dyI1\n");
%             fflush(trackLogFile);
            delete 'dyI1';
%             fprintf(trackLogFile, "Freeing dzI1\n");
%             fflush(trackLogFile);
            delete 'dzI1';
%             fprintf(trackLogFile, "Freeing dxI2\n");
%             fflush(trackLogFile);
            delete 'dxI2';
%             fprintf(trackLogFile, "Freeing dyI2\n");
%             fflush(trackLogFile);
            delete 'dyI2';
%             fprintf(trackLogFile, "Freeing dzI2\n");
%             fflush(trackLogFile);
            delete 'dzI2';
%             fprintf(trackLogFile, "Freeing weight\n");
%             fflush(trackLogFile);
            delete 'weight';
%             fprintf(trackLogFile, "Freeing rI1->pix\n");
%             fflush(trackLogFile);
            delete 'rI1->pix';
%             fprintf(trackLogFile, "Freeing rI2->pix\n");
%             fflush(trackLogFile);
            delete 'rI2->pix';
%             fprintf(trackLogFile, "\tFreeing xI2->pix\n");
%             fflush(trackLogFile);
            delete 'xI2->pix';
%             fprintf(trackLogFile, "Done\n");
%             fflush(trackLogFile);
        
    end
    delete 'S';
	delete 'b';
	delete 'temp_v1';
	delete 'temp_v2';
    delete 'A';
	delete 'dA';
	delete 'dxA';
	delete 'dyA';
	delete 'dzA';
	delete 'temp_mat';
	delete 'theta';
	delete 'xI2';
	delete 'rI1';
	delete 'rI2';
    
    %fclose(trackFile);
	%fclose(trackLogFile);
    if (zero_overlap_flag) 
		best_A=  eye(4);
		%return -2;
    end
	%return 0;
            
end
   



