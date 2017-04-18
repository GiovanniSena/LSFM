function [ output_args ] = myDeconv( input_args )
%MYDECONV Summary of this function goes here
%   Detailed explanation goes here
    myFolder= 'D:\LSM_Data\';
    fileName= 'Run0022_tp000.tif';
    %fileName= 'Run0001_151005_1634.tif';
    rawImage=TIFF_read([myFolder fileName]);
    
    myFolderPSF= 'D:\LSM_Data\160805 PSF\A\results\';
    fileName= 'myPSF.tif';
    psfImage=TIFF_read([myFolderPSF fileName]);
    
    % Remove noise from raw image
    noisePedestal=9;
    rawImage= rawImage- noisePedestal;
    
    % Remove extra slides from PSF
    umStack= 3.2; %microns per step in the stack
    umPSF= 1; %microns per step in the psf
    
    umratio= round(umStack/umPSF);
    psfImage= psfImage(:,:, 1 : umratio : end);
    %TIFF_writeStack(psfImage, [myFolderPSF 'check.tif']);
    %colormap('gray');
    %image(rawImage);
    tic();
    
    %BLIND
     INITPSF = ones(10);
     [decImg, PSF]=deconvblind(rawImage, INITPSF, 10);
     %image(decImg);
     %TIFF_write(decImg, [myFolder 'deconBlind.tif']);
     TIFF_writeStack(decImg, [myFolder 'deconBlind.tif']); 
    
    %Normalize
    integrale= sum(psfImage(:));
    psfImage= single(psfImage);
    psfImage= psfImage/integrale;
    dampar= uint16(5);
    
    [ySize, xSize, zSize]=size(rawImage);
    pixelMask=ones(ySize, xSize, zSize);
    
    %LUCY METHOD
    %lucyImg = deconvlucy(rawImage,psfImage, 10,dampar, pixelMask);
    %TIFF_writeStack(lucyImg, [myFolder 'Run0022_tp000_dcnv.tif']);
    
    %REGULARIZED (do not use)
    %regImg = deconvreg(rawImage, double(psfImage));
    %TIFF_writeStack(regImg, [myFolder 'reg.tif']);
    
    toc();
end

