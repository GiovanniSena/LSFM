function [ output_args ] = ImageAnalysys_test( input_args )
%% OPENFILE_TEST Summary of this function goes here
%   Detailed explanation goes here

 % LOAD 2 NY IMAGES
 disp('=========================START==============================');
    inFile = 'D:\Images\NY_images\raw_exp1_sc54.tif';
    InitialImage= TIFF_read(inFile);
    
    inFile = 'D:\Images\NY_images\raw_exp1_sc53.tif';
    FinalImage= TIFF_read(inFile);
    [ ~,~, NumberImages ]= size(FinalImage);
    
 % EXTRACT ROI FROM IMAGES
    ROI_In = InitialImage(20:499, 410:690, :);
    TIFF_writeStack(ROI_In, 'D:\Images\NY_images\ROI_In.tif');
    ROI_In = smoothImg(ROI_In, 2, 2, 1);
    
    ROI_Fi = FinalImage(20:499, 410:690, :);
    TIFF_writeStack(ROI_Fi, 'D:\Images\NY_images\ROI_Fi.tif');
    ROI_Fi = smoothImg(ROI_Fi, 2, 2, 1);
    
 
 % 
    [optimizer, metric] = imregconfig('monomodal');
 
 % METRIC
    metric = registration.metric.MeanSquares();
    
%     metric = registration.metric.MattesMutualInformation();
%     metric.NumberOfSpatialSamples= 5000;
%     metric.NumberOfHistogramBins= 50;
%     metric.UseAllPixels = 1;
 
 % OPTIMIZER   
    % ONE PLUS
    %optimizer = registration.optimizer.OnePlusOneEvolutionary;
    %optimizer.InitialRadius = 6.250000e-04;
    %optimizer.Epsilon = 1.5e-4;
    %optimizer.GrowthFactor = 1.01;
    %optimizer.MaximumIterations = 300;
    
    % REGULAR STEP
    optimizer = registration.optimizer.RegularStepGradientDescent;
    optimizer.GradientMagnitudeTolerance= 1e-01; % DEFAULT 1e-04 When the value of the gradient is smaller than GradientMagnitudeTolerance, it is an indication that the optimizer might have reached a plateau.
    optimizer.MinimumStepLength = 1e-4; % DEFAULT 1e-05 accuracy of convergence
    optimizer.MaximumStepLength = 1.25e-2; % DEFAULT 6.25e-02  initial step length used in optimization
    optimizer.MaximumIterations = 100; % DEFAULT 100
    optimizer.RelaxationFactor = 0.3; %[0,1] 1 means more stable results but longer time
    
    
    %optimizer.InitialRadius = 0.009;
    %optimizer.Epsilon = 1.5e-1; %DEFAULT 1.5e-4
    %optimizer.GrowthFactor = 1.01;
    
    tic;
 % FIND A TRANSLATION TO START
    %t_trasl = imregtform(FinalImage, InitialImage, 'translation', optimizer, metric, 'DisplayOptimization',0 , 'PyramidLevels',3 );
    %disp('TRANSLATION MATRIX');
    %disp(t_trasl.T)
 % FEED TRANSLATION AS STARTING MATRIX FOR GLOBAL TRANSLATION   
    %optimizer.MaximumStepLength = 6.25e-3;
    %optimizer.MinimumStepLength = 1e-2;
tform = imregtform(ROI_In, ROI_Fi, 'rigid', optimizer, metric, 'DisplayOptimization',1 , 'PyramidLevels',3);
    %tform = affine3d(); % UNITARY MATRIX
    
    %tform = imregtform(FinalImage, InitialImage, 'rigid', optimizer, metric, 'DisplayOptimization',0 , 'PyramidLevels',3, 'InitialTransformation', t_trasl );
    
    disp('FINAL MATRIX');
%     disp(tform.T)
    disp('ELAPSED TIME ' );
    disp(toc);
    
%     A= [1.0000    0.0050   -0.0010  0
%         -0.0050   1.0000   -0.0017      0
%         0.0010    0.0017    1.0000 0
%         -2.0016   -0.4221    0.2852    1.0000];
%    tform = affine3d(A); 
    RegisteredImage = imwarp(ROI_In, tform);
%size(RegisteredImage);
    
    TIFF_writeStack(RegisteredImage, 'D:\Images\NY_images\ROI_Al.tif');

    
 disp('=========================STOP===============================');
    %sliceomatic(FinalImage);
   %set(gcf, 'Renderer', 'OpenGL');
   
   clear;
end

