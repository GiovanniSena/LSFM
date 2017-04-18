function [ best_A, RA ] = tr_findTransfMatlab_mine( prevStack, curStack, tType, xmm_pixel, ymm_pixel, zmm_pixel,  best_A)
%%  commented by GS (28/10/2016)
%  tr_findTransfMatlab_mine: find the transformation matrix that registers curStack onto prevStack
%  tType = rigid (rototranlsation), translation (just translation)
%  xmm_pixel and ymm_pixel = the dimension of one pixel in mm : NOTE that we call these X and Z dimensions...
 % zmm_pixel = the distance between slices in mm: NOTE that we call this Y dimension...

 %   The function also returns the spatial reference used for the
 %   transofrmation, RA
        
        
 % DEFINE SPATIAL COORDINATES in mm
    %RA = imref3d(size(curStack),  xmm_pixel/1000, ymm_pixel/1000, zmm_pixel);
    % new nomenclature (see my start_call_GS) to keep everything in mm
    RA = imref3d(size(curStack),  xmm_pixel, ymm_pixel, zmm_pixel);
    %fprintf('1 PXL= %3.4f um in X, %3.4f um in Y and %3.4f um in Z\n', xmm_pixel, ymm_pixel, zmm_pixel*1000);

 %%%%%% FIND A
    % parameters
    [optimizer, metric] = imregconfig('monomodal'); %#ok<ASGLU>
    metric = registration.metric.MeanSquares();

    optimizer = registration.optimizer.RegularStepGradientDescent;
    optimizer.MaximumStepLength = 0.0001 ; %0.0001 DEFAULT 6.25e-02  initial step length used in optimization
    optimizer.MaximumIterations = 500; % DEFAULT 100
    optimizer.GradientMagnitudeTolerance= 1e-05; % DEFAULT 1e-04 When the value of the gradient is smaller than GradientMagnitudeTolerance, it is an indication that the optimizer might have reached a plateau.
    optimizer.MinimumStepLength = 5e-06; % DEFAULT 1e-05 accuracy of convergence

       % type of transformation (defined in "transftype" of config.ini, read in start_call and passed to this function
       % 'rigid'=roto-translation; 'translation'=no rotation;
       % 'affine'=roto-translation+scale+shear
       % by default we prefer to use 'affine', to calculate the best possible transformation that brings the root from one time-pont to the next. But we will implement the translational part only.
%        doRigid = strcmp(tType, 'rigid');
%     if (doRigid)
%         transformType= 'rigid';
%     else
%         transformType= 'translation';
%     end
    transformType=tType;
    fprintf('Finding tform with %s transformation... ', transformType);
    
    %%% finding the actual transformation, using the function imregtform
    currTrasf = affine3d(best_A); %best_A has initially be defined as identity (line 138 in start_call)
    verboseOutput= 0; % Set this to 1 to see the output of the optimizer. This will slow down everything, so do not use during real scans!
    currTrasf = imregtform(prevStack, RA, curStack,  RA, transformType, optimizer, metric, 'DisplayOptimization', verboseOutput , 'PyramidLevels', 3, 'InitialTransformation', currTrasf);
    best_A= currTrasf.T; % inverse?
    fprintf('Done!\n');
    disp(best_A);
    %helperVolumeRegistration(tmpI2,tmpI1);


    %%%%%%%%%%%%%%%%%%%%%%%%%% SAVE IMAGES TO CHECK (DISABLE FOR REAL RUN)
%     filename= ['D:\Images\myImages\fixed_raw_test'  '.tif'];
%     TIFF_writeStack(prevStack, filename);
% 
%     filename= ['D:\Images\myImages\moved_test'  '.tif'];
%     TIFF_writeStack(curStack, filename);
% 
    %tmpI1adj= tr_applyTransfRef(best_A, prevStack, RA, RA);
    %filename= ['D:\LSM_Data\OldFiles\150922_TrackFiles\adj_test'  '.tif'];
    %TIFF_writeStack(tmpI1adj, filename);


   
end
   



