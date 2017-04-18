function [ best_A, RA ] = tr_findTransfMatlab_mine( prevStack, curStack, tType, xmm_pixel, ymm_pixel, zmm_pixel,  best_A)

% v161027

%  tr_findTransfMatlab_mine: find the transformation matrix that registers curStack onto prevStack
%  tType = rigid (rototranlsation), translation (just translation)
%  xmm_pixel and ymm_pixel = the dimension of one pixel in mm : note that WE call these X and Z dimensions...
 % zmm_pixel = the distance between slices in mm: NOTE that we call this Y dimension...
                
 % DEFINE SPATIAL COORDINATES in mm; RA is used in imregtform as the 'spatial referencing objects' RMOVING & RFIXED
    RA = imref3d(size(curStack), xmm_pixel, ymm_pixel, zmm_pixel);
    

    % parameters
    [optimizer, metric] = imregconfig('monomodal');
    metric = registration.metric.MeanSquares();

    optimizer = registration.optimizer.RegularStepGradientDescent;
    optimizer.MaximumStepLength = 0.0001 ; %0.0001 DEFAULT 6.25e-02  initial step length used in optimization
    optimizer.MaximumIterations = 500; % DEFAULT 100
    optimizer.GradientMagnitudeTolerance= 1e-05; % DEFAULT 1e-04 When the value of the gradient is smaller than GradientMagnitudeTolerance, it is an indication that the optimizer might have reached a plateau.
    optimizer.MinimumStepLength = 5e-06; % DEFAULT 1e-05 accuracy of convergence
    
%%% finding the actual transformation, using the function imregtform
% 'transftype'= type of transformation (defined in "transftype" of config.ini, read in start_call and passed to this function
% 'rigid'=roto-translation; 'translation'=no rotation; 'affine'=roto-translation+scale+shear
       
    fprintf('Finding tform with %s transformation... ', transfType);   
    currTrasf = affine3d(best_A); %best_A has initially be defined as identity 
    verboseOutput= 0; % Set this to 1 to see the output of the optimizer. This will slow down everything, so do not use during real scans!
    currTrasf = imregtform(prevStack, RA, curStack,  RA, transftype, optimizer, metric, 'DisplayOptimization', verboseOutput , 'PyramidLevels', 3, 'InitialTransformation', currTrasf);
    best_A= currTrasf.T; % extract the actual matrix from the output of imregtform
    fprintf('Done!\n');
    disp(best_A);
 
end
   



