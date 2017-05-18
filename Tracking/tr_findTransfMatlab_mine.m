function [ best_A, RA ] = tr_findTransfMatlab_mine( prevStack, curStack, tType, xmm_pixel, ymm_pixel, zmm_pixel,  best_A)
%%  TR_FINDTRANSFMATLAB_MINE Find the transformation matrix that registers curStack onto prevStack
%   This function takes two stack of images and attempts to find the best
%   tranformation that registers one stack to the other. The transformation
%   type can be specified by the user:
%   tType = rigid (rototranlsation), translation (just translation)
%   The user must also provide accurate estimates for the pixel dimensions
%   in X, Y and Z to ensure that the resulting transformation is
%   meaningful.
%   An initial estimate of the matrix must be provided. If no information
%   is known, use a unitary matrix (i.e. eye(4)).
%   xmm_pixel and ymm_pixel = the dimension of one pixel in mm (NOTE that that in the microscope these are X and Z dimensions)
%   zmm_pixel = the distance between slices in mm (NOTE that in the microscope this is the Y dimension)
%   The function also returns the spatial reference used for the
%   transofrmation, RA
%   commented by GS (28/10/2016)
        
        
%   Define spatial coordinates in mm
    RA = imref3d(size(curStack),  xmm_pixel, ymm_pixel, zmm_pixel);
    
%   Define optimization strategy parameters
    [optimizer, metric] = imregconfig('monomodal'); %#ok<ASGLU>
    metric = registration.metric.MeanSquares();

    optimizer = registration.optimizer.RegularStepGradientDescent;
    optimizer.MaximumStepLength = 0.0001 ; %0.0001 DEFAULT 6.25e-02  initial step length used in optimization
    optimizer.MaximumIterations = 500; % DEFAULT 100
    optimizer.GradientMagnitudeTolerance= 1e-05; % DEFAULT 1e-04 When the value of the gradient is smaller than GradientMagnitudeTolerance, it is an indication that the optimizer might have reached a plateau.
    optimizer.MinimumStepLength = 5e-06; % DEFAULT 1e-05 accuracy of convergence

    transformType=tType;
    fprintf('Finding tform with %s transformation... ', transformType);
    
%   Find transformation using the function imregtform
    currTrasf = affine3d(best_A); %best_A has initially be defined as identity (line 138 in start_call)
    verboseOutput= 0; % Set this to 1 to see the output of the optimizer. This will slow down everything, so do not use during real scans!
    currTrasf = imregtform(prevStack, RA, curStack,  RA, transformType, optimizer, metric, 'DisplayOptimization', verboseOutput , 'PyramidLevels', 3, 'InitialTransformation', currTrasf);
%   Extract matric from tform
    best_A= currTrasf.T;
    fprintf('Done!\n');
    disp(best_A);
    %helperVolumeRegistration(tmpI2,tmpI1);
end
   



