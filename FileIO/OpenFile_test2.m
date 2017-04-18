function [ output_args ] = OpenFile_test2( input_args )
%OPENFILE_TEST Summary of this function goes here
%   Detailed explanation goes here
    %A = imread('D:\Images\Test\testImg_1.tiff');
    %B = imread('D:\Images\Test\testImg_2.tiff');
    %imshow(A, [0,4095] );
    
    %inFile = 'D:\Images\Test\testWriteTiff_redone.tif';
    inFile = 'D:\Images\NY_images\raw_exp1_sc53.tif';
    InitialImage= TIFF_read(inFile);
    
    inFile = 'D:\Images\NY_images\raw_exp1_sc52.tif';
    FinalImage= TIFF_read(inFile);
    [ ~,~, NumberImages ]= size(FinalImage);
    
    
    [optimizer, metric] = imregconfig('monomodal');
    optimizer = registration.optimizer.RegularStepGradientDescent;
    metric = registration.metric.MeanSquares;
    
    optimizer.MaximumStepLength = 3.25e-2;
    optimizer.MaximumIterations = 200;
    %optimizer.MinimumStepLength = 5e-4;
    
    %optimizer.RegularStepGradientDescent
    %optimizer.InitialRadius = 0.009;
    %optimizer.Epsilon = 1.5e-4;
    %optimizer.GrowthFactor = 1.01;
    tic;
    tform = imregtform(FinalImage, InitialImage, 'rigid', optimizer, metric, 'DisplayOptimization',1 , 'PyramidLevels',3 );
    disp(tform.T)
    disp('ELAPSED TIME ' );
    disp(toc);
    

    

    %sliceomatic(FinalImage);
   %set(gcf, 'Renderer', 'OpenGL');
   
   clear;
end

