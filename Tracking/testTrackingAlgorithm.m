 % LOAD IMAGES
    inFile = 'D:\LSM_Data\OldFiles\151005_TestWithPlant\Run0001_151005_1634.tif';
    initialStack= TIFF_read(inFile);
    initialTxt= strrep(inFile, '.tif', '.txt');
    initialCoord = readLogFile(initialTxt);

    inFile = 'D:\LSM_Data\OldFiles\151005_TestWithPlant\Run0001_151005_1642.tif';
    finalStack= TIFF_read(inFile);
    finalTxt= strrep(inFile, '.tif', '.txt');
    finalCoord = readLogFile(finalTxt);

    [width, height, depth]= size(initialStack);
    
 % START TIMER
    tStart = tic;

 % DEFINE CONSTANTS
    xum_pixel= 0.14198;
    yum_pixel= 0.14161;
    zmm_pixel= initialCoord{7}; % FROM LOG FILE
    
 % EXTRACT ROI
    ROI= [0, 1, 0, 1, 0, 1];
    if ~isequal(ROI , [0, 1, 0, 1, 0, 1]);
        initialStack_ROI= tr_extractROI(initialStack, ROI);
        finalStack_ROI= tr_extractROI(finalStack, ROI);
    else
        initialStack_ROI= initialStack;
        finalStack_ROI= finalStack;
    end
    
 % SCALE
    xy_scalefactor= 4;
    if xy_scalefactor~= 1
        prevImg = tr_resizeStack(initialStack_ROI, xy_scalefactor, 1);
        currImg = tr_resizeStack(finalStack_ROI, xy_scalefactor, 1);
    else
        prevImg= initialStack_ROI;
        currImg= finalStack_ROI;
    end
    
 % SMOOTH
%     prevImg = tr_smoothImg(prevImg, 1.5, 1.5, 1);
%     currImg = tr_smoothImg(currImg, 1.5, 1.5, 1);
    

%%% FIND AFFINE TRANSFORMATION
    best_A= eye(4);
    trasfType= 'rigid'; %USE 'rigid' or 'translation'
    %best_A= tr_findTransfMatlab_mine(prevImg, currImg, xum_pixel*xy_scalefactor, yum_pixel*xy_scalefactor, zmm_pixel,  best_A);
    [best_A, ~]= tr_findTransfMatlab_mine(prevImg(16:end-15, 16:end-15, 2:end-1), currImg(16:end-15, 16:end-15, 2:end-1), trasfType, xum_pixel*xy_scalefactor, yum_pixel*xy_scalefactor, zmm_pixel,  best_A);
    
%%%
    
  % SPATIAL REFERENCE FOR TRANSFORMED IMAGE
    RAinv = imref3d(size(finalStack_ROI),  xum_pixel/1000, yum_pixel/1000, zmm_pixel); 
    tr_transformCurrentStack( finalStack_ROI, best_A, RAinv );
    
    %eul = tform2eul(best_A); %requires robotics system toolbox
    %disp(eul);

    fprintf('DELTA_X_real= %3.2f um; CALCULATED= %3.2f um\n', (initialCoord{2}-finalCoord{2})*1000, best_A(4,2)*1000);
    fprintf('DELTA_Y_real= %3.2f um; CALCULATED= %3.2f um\n', (initialCoord{3}-finalCoord{3})*1000, best_A(4,3)*1000);
    fprintf('DELTA_Z_real= %3.2f um; CALCULATED= %3.2f um\n', (initialCoord{4}-finalCoord{4})*1000, best_A(4,1)*1000);
    fprintf('DELTA_C_real= %3.2f um\n', (initialCoord{5}-finalCoord{5})*1000);
    fprintf('DELTA_F_real= %3.2f um\n', (initialCoord{6}-finalCoord{6})*1000);
    thetaX= atan2(-best_A(3,2) , best_A(3,3));
    fprintf('ThetaX= %1.3f (%2.1f deg)\n', thetaX, radtodeg(thetaX));
    thetaY= atan2( best_A(3,1) , sqrt( power(best_A(3,2),2)+power(best_A(3,3),2) ));
    fprintf('ThetaY= %1.3f (%2.1f deg)\n', thetaY, radtodeg(thetaY));
    thetaZ= atan2(-best_A(2,1) , best_A(1,1));
    fprintf('ThetaZ= %1.3f (%2.1f deg)\n', thetaZ, radtodeg(thetaZ));
    
    tEnd = toc(tStart);
    fprintf('ELAPSED: %d minutes and %2.1f seconds\n',floor(tEnd/60),rem(tEnd,60));
    

    
    