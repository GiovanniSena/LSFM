function [ best_A ] = findTransfMatlab( prevStack, curStack, scale0, scale1, scaleMult, nIterations, z_over_x, L )
%% 
%

    I1 = prevStack;
    I2 = curStack;
 % INITIAL PARAMETERS MINE
    [imgW, imgH, imgD] = size(curStack);

    
    ROI_x1 = 410;
    ROI_x2 = 690;
    ROI_y1 = 20; 
    ROI_y2 = 499;
    ROI= [ROI_x1/imgW, ROI_x2/imgW, ROI_y1/imgH, ROI_y2/imgH, 0, 1];
    TRACK_X = (ROI_x1+ROI_x2)/2;
    TRACK_Y = (ROI_y1+ROI_y2)/2;
    
    theta = zeros(1, 3);
    S = zeros(6);
    b= zeros(1, 6);
    
    temp_v1 = zeros(1, 4);
	temp_v2 = zeros(1, 4);

	dA = zeros(4);
	dxA = zeros(4);
	dyA = zeros(4);
	dzA = zeros(4);
	temp_mat = zeros(4);

    best_A = eye(4); % IDENTITY 4x4
    scales=[4, 2, 1];
    for myScale= scales
        disp(num2str(myScale));
        
        
    end
            
end
   



