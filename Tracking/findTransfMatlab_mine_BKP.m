function [ best_A ] = findTransfMatlab_mine( prevStack, curStack, xmm_pixel, ymm_pixel, zmm_pixel, best_A)
%% 
% 
    
    %scale0 = 5;
    %scale1 = 1.25;
    %nSteps= floor(log(scale1/scale0)/log(scaleMult))+1;
    %scales= [5, 4, 3, 2, 1];
    scales= [1];
    
    %best_A = eye(4); % IDENTITY 4x4
    
    %EXTRACT ROIs
    %ROI= [0.35, 0.96, 0.47, 0.993, 0, 1];%<-
    ROI= [0, 1, 0, 1, 0, 1];
    ROI_1_fix= tr_extractROI(prevStack, ROI);
    ROI_2_move= tr_extractROI(curStack, ROI);
    
    
    scale_z = 1;
    for i= 1:numel(scales)
        scale_xy= scales(i);
        szStr=['Start tracking at scale_xy= 1:' num2str(scale_xy)];
        disp(szStr);
        
        %RESCALE A FROM PREVIOUS STEP
        if i~=1
            %best_A(4,1) = best_A(4, 1)*scales(i)/scales(i-1);
            %best_A(4,2) = best_A(4, 2)*scales(i)/scales(i-1);
            %best_A(4,3) = best_A(4, 3);
        end
        disp(best_A);
        
        %flush
        
                
        %SCALE IMAGES
        %tmp_fix = tr_resizeStack(ROI_1_fix, scale_xy, 1);
        %tmp_move = tr_resizeStack(ROI_2_move, scale_xy, 1);
        tmp_fix = tr_resizeStack(ROI_1_fix, 4, 1);
        tmp_move = tr_resizeStack(ROI_2_move, 4, 1);
        
        %SMOOTH IMAGES (except last iteration)
%         if (scale_xy ~= 1)
%             tmp_fix = tr_smoothImg(tmp_fix, 1.5, 1.5, 1);
%             filename= ['D:\Images\myImages\fixed_smooth_' num2str(scales(i)) '.tif']
%             TIFF_writeStack(tmp_fix, filename);
%             tmp_move = tr_smoothImg(tmp_move, 1.5, 1.5, 1);
%             filename= ['D:\Images\myImages\moved_smooth_' num2str(scales(i)) '.tif']
%             TIFF_writeStack(tmp_move, filename);
%         end
        
        %DEFINE SPATIAL REFERENCE
        %xmm_pixel= 0.000145; % 1 pixel = 0.141 um
        %ymm_pixel= 0.000145; % 1 pixel = 0.145 um
        %zmm_pixel= 0.0005; % 0.5 um slices
        RA = imref3d(size(tmp_move),  xmm_pixel*scale_xy, ymm_pixel*scale_xy, zmm_pixel*scale_z);
        myMsg= ['1 px = ' num2str(xmm_pixel*scale_xy) ' mm in X and Y. 1 px = ' num2str(zmm_pixel*scale_z) ' mm in Z'];
        disp(myMsg);
        
        %FIND A
        [optimizer, metric] = imregconfig('monomodal');
        metric = registration.metric.MeanSquares();
        
        optimizer = registration.optimizer.RegularStepGradientDescent;
        optimizer.MaximumStepLength = 0.0001 ; %0.0001 DEFAULT 6.25e-02  initial step length used in optimization
        optimizer.MaximumIterations = 700; % DEFAULT 100
        optimizer.GradientMagnitudeTolerance= 1e-05; % DEFAULT 1e-04 When the value of the gradient is smaller than GradientMagnitudeTolerance, it is an indication that the optimizer might have reached a plateau.
        optimizer.MinimumStepLength = 5e-06; % DEFAULT 1e-05 accuracy of convergence
        
        myMsg= ['Finding tform...'];
        disp(myMsg);
        currTrasf = affine3d(best_A);
        %currTrasf = imregtform(tmp_fix, RA, tmp_move,  RA, 'rigid', optimizer, metric, 'DisplayOptimization', 1 , 'PyramidLevels', 3, 'InitialTransformation', currTrasf);
        currTrasf = imregtform(tmp_fix, RA, tmp_move,  RA, 'rigid', optimizer, metric, 'DisplayOptimization', 1 , 'PyramidLevels', 3, 'InitialTransformation', currTrasf);
        %currTrasf = imregtform(tmpI1, RA, tmpI2,  RA, 'rigid', optimizer, metric, 'DisplayOptimization', 0 , 'PyramidLevels', 2 )

        best_A= currTrasf.T
        myMsg= ['Tform found'];
        disp(myMsg);
        %helperVolumeRegistration(tmpI2,tmpI1);
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        filename= ['D:\Images\myImages\fixed_raw_' num2str(scales(i)) '.tif'];
        TIFF_writeStack(tmp_fix, filename);
        
        filename= ['D:\Images\myImages\moved_' num2str(scales(i)) '.tif'];
        TIFF_writeStack(tmp_move, filename);
        
        tmpI1adj= tr_applyTransfRef(best_A, tmp_fix, RA, RA);
        filename= ['D:\Images\myImages\fixed_adj_' num2str(scales(i)) '.tif'];
        TIFF_writeStack(tmpI1adj, filename);
        
        fprintf('DONE!\n');

    end %END nSteps LOOP
   
end
   



