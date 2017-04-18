function [ output_args ] = testTrack( input_args )
%% =========== USE THIS ===========
%   
    best_L2= Inf;
    L= 100;
    inFile = 'D:\Images\myImages\Testing\fixed_Small.tif';
    InitialStack= TIFF_read(inFile);

    inFile = 'D:\Images\myImages\Testing\moved_Small.tif';
    FinalStack= TIFF_read(inFile);

    [width, height, depth]= size(InitialStack);
    
 %========================================
    
    theta= [0.00, 0.0, 0.00];
    displace= [0, 0, 0];
    [Rmatrix, dxR, dyR, dzR]=tr_Rmatrix(theta, displace);
 %========================================   
    
    adjStack= tr_applyTransf(Rmatrix, FinalStack); % Final image has been transformed using Rmatrix
    L2= tr_calcL2(InitialStack, adjStack); % Calc difference between initial and adjusted final
    
    if L2 < best_L2
        disp(['New L2 is better: ' num2str(L2) ' vs ' num2str(best_L2)]);
        best_L2= L2;
        best_R= Rmatrix;
    end
    
    sigma= zeros(27, 1);
    
    disp('Calc weight');
    weightMatrix= tr_weight(InitialStack, adjStack, L);
    
    disp('Calc tracking');
    tr_calcTrackTerms(InitialStack, adjStack, Rmatrix, dxR, dyR, dzR, weightMatrix, sigma);
    
    %filename= ['D:\Images\myImages\moving_adj_.tif']
    %TIFF_writeStack(adjStack, filename);
    
    %filename= ['D:\Images\myImages\derive.tif']
    %adjStack= tr_deriveImg(InitialStack, 2, 1);
    %TIFF_writeStack(adjStack, filename);
    
    
    
    
    
    
end

