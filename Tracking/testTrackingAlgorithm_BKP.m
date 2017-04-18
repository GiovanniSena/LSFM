inFile = 'D:\LSM_Data\trackingtests\150813_track_1.tif';
initialStack= TIFF_read(inFile);
initialTxt= strrep(inFile, '.tif', '.txt');
initialCoord = readLogFile(initialTxt);

inFile = 'D:\LSM_Data\trackingtests\150813_track_9.tif';
finalStack= TIFF_read(inFile);
finalTxt= strrep(inFile, '.tif', '.txt');
finalCoord = readLogFile(finalTxt);

[width, height, depth]= size(initialStack);

tStart = tic;

best_A= eye(4);
%%%%%%%%
% halfInitial= tr_resizeStack(initialStack, 2, 1);
% halfFinal= tr_resizeStack(finalStack, 2, 1);
% best_B= findTransfMatlab_mine(halfInitial, halfFinal, 0.000145, 0.000145, initialCoord{7},  best_A);
% 
% best_A(4,1)= best_B(4,1)*2;
% best_A(4,2)= best_B(4,2)*2;
% best_A(4,3)= best_B(4,3)*1;

%%%%%%%%
best_A= findTransfMatlab_mine(initialStack, finalStack, 0.000145, 0.000145, initialCoord{7},  best_A);
%%%%%%%%

%             inFile = 'D:\Images\myImages\test_plant_slicenoise.tif';
%             noiseStack= TIFF_read(inFile);
%             h1= histogram(noiseStack);
%             h1.BinWidth = 1;
%             % hold on;
%             h2= histogram(InitialStack);
%             h2.BinWidth = 1;
%             [pedImg, noisImg ]=tr_avgNoise(noiseStack);
%             %outImg =  bsxfun(@minus, InitialStack, uint16(noisImg*3));
%             outImg =  bsxfun(@minus, InitialStack, uint16(pedImg));
%             TIFF_writeStack(outImg, 'D:\Images\myImages\subNoise.tif');

%RegisteredImage= resizeStack(InitialImage, 5, 1);
%RegisteredImage= applyTransf(Rtrasla, InitialImage); % OK
%TIFF_writeStack(RegisteredImage, 'D:\Images\NY_images\resizeFifth.tif');
%savethis= tr_extractROI(InitialImage, [0.038, 0.96, 0.59, 0.993, 0, 1]);
%TIFF_writeStack(savethis, 'D:\Images\NY_images\_ROI_.tif');
% 
% savethis= tr_resizeStack(InitialImage, 1.3, 1);
% TIFF_writeStack(savethis, 'D:\Images\NY_images\_Scaled_.tif');
% 
% savethis= tr_smoothImg(InitialImage, 0.5, 0.5, 1);
% TIFF_writeStack(savethis, 'D:\Images\NY_images\_Smooth_2.tif');


    fprintf('DELTA_X_real= %3.4f um; CALCULATED= %3.4f\n', initialCoord{2}-finalCoord{2}, best_A(4,2));
    fprintf('DELTA_Y_real= %3.4f um; CALCULATED= %3.4f\n', initialCoord{3}-finalCoord{3}, best_A(4,3));
    fprintf('DELTA_Z_real= %3.4f um; CALCULATED= %3.4f\n', initialCoord{4}-finalCoord{4}, best_A(4,1));
    fprintf('DELTA_C_real= %3.4f um\n', initialCoord{5}-finalCoord{5});
    fprintf('DELTA_F_real= %3.4f um\n', initialCoord{6}-finalCoord{6});
    


tEnd = toc(tStart);
fprintf('ELAPSED: %d minutes and %2.1f seconds\n',floor(tEnd/60),rem(tEnd,60));
