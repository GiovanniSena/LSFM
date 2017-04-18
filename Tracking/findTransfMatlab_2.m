function [ best_A ] = findTransfMatlab_2( prevStack, curStack, scale0, scale1, scaleMult, nIterations, z_over_x, L )
%% 
%
    
    scale0 = 5;
    scale1 = 1.25;
    nSteps= floor(log(scale1/scale0)/log(scaleMult))+1;
    
    dA = zeros(4);
	dxA = zeros(4);
	dyA = zeros(4);
	dzA = zeros(4);
	temp_mat = zeros(4);
    best_A = eye(4); % IDENTITY 4x4
    
    %EXTRACT ROIs
    %ROI= [0.038, 0.96, 0.59, 0.993, 0, 1];
    ROI= [0.35, 0.96, 0.47, 0.993, 0, 1];
    ROI_1= tr_extractROI(prevStack, ROI);
    ROI_2= tr_extractROI(curStack, ROI);
    
    scale_xy = scale0;
    scale_z = 1;
    for step= 1: nSteps+1
        
        szStr=['Start tracking at scale_xy= :' num2str(scale_xy)];
        disp(szStr);
        disp(best_A);
        %flush
        best_L2 = realmax;
                
        %SCALE IMAGES
        tmpI1 = tr_resizeStack(ROI_1, scale_xy, 1);
        tmpI2 = tr_resizeStack(ROI_2, scale_xy, 1);
        
        %SMOOTH IMAGES (except last iteration)
        if (scale ~= 1)
            tmpI1 = tr_smoothImg(tmpI1, 2, 2, 1);
            tmpI2 = tr_smoothImg(tmpI2, 2, 2, 1);
        end
        
        %DEFINE SPATIAL REFERENCE
        %xmm_pixel= 0.008;
        %ymm_pixel= 0.008;
        %zmm_pixel= 0.005; %5 um slices
        xmm_pixel= 0.0033;
        ymm_pixel= 0.0033;
        zmm_pixel= 0.1; %100 um slices
        RA = imref3d(size(tmpI1),  xmm_pixel*scale_xy, ymm_pixel*scale_xy, zmm_pixel*scale_z);
        
        
        %FIND A
        [optimizer, metric] = imregconfig('monomodal');
        metric = registration.metric.MeanSquares();
        
        optimizer = registration.optimizer.RegularStepGradientDescent;
        optimizer.MaximumStepLength = 1.25e-3; % DEFAULT 6.25e-02  initial step length used in optimization
        optimizer.MaximumIterations = 500; % DEFAULT 100
        optimizer.GradientMagnitudeTolerance= 1e-03; % DEFAULT 1e-04 When the value of the gradient is smaller than GradientMagnitudeTolerance, it is an indication that the optimizer might have reached a plateau.
        optimizer.MinimumStepLength = 1e-5; % DEFAULT 1e-05 accuracy of convergence
        
        myMsg= ['Finding tform...'];
        disp(myMsg);
        currTrasf = affine3d(best_A);
        currTrasf = imregtform(tmpI1, RA, tmpI2,  RA, 'rigid', optimizer, metric, 'DisplayOptimization', 1 , 'PyramidLevels', 2, 'InitialTransformation', currTrasf)
        best_A= currTrasf.T
        
        %RESCALE A FOR NEXT STEP
        A(4,1) = A(4, 1)* scale_xy;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        scale_xy = scale_xy*scaleMult;
        if scale_xy <1
            scale_xy=1;
        end
    end %END nSteps LOOP
   
end
   



