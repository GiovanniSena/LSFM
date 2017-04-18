function [ output_args ] = PSF_merge( input_args )
 %% PSF_MERGE Merge PSF images and average them
 %  All the files in the imageFolder must be stacks of PSF images.
 %  The code will merge and average them to create a single one.
 %  The images are assumed to be centered in X and Y. The X center can vary
 %  from stack to stack but the user must specify which stack represents
 %  the "center" of the PSF (best bead focus) in the "maxZ" array.
 
    imageFolder= 'S:\LiSM data\160805 PSF\A\results\';
    fileList=dir( [imageFolder '*.tif']);
    [nFiles,~]=size(fileList);
    myPSF= [];
    
    myTest= TIFF_read([imageFolder fileList(1).name]);
    [ySize, xSize, zSize]=size(myTest);
    myPSF= zeros(ySize, xSize, 2*zSize);
    myPSF= double(myPSF);
    maxZ= [9, 14, 7, 6, 9, 14, 17, 5, 7, 9, 11, 16, 16, 11, 12, 15];
    for iFile=1:nFiles
        fileName= fileList(iFile).name;
        fprintf('OPENING FILE %s\n', char(fileName));
        myStack= TIFF_read([imageFolder fileName]);
        myStack= double(myStack);
        
        % Get intensity max near the center of file and renormalize stack
        [ySize, xSize, zSize]=size(myStack);
        nearSize= 20;
        yMin= round(ySize/2) - nearSize;
        yMax= round(ySize/2) + nearSize;
        xMin= round(xSize/2) - nearSize;
        xMax= round(xSize/2) + nearSize;
        nearBead= myStack(yMin:yMax, xMin:xMax, :);
        
        % Find Z slice with highest intensity
        integralImage= sum(nearBead);
        integralImage= sum(integralImage);
        maxInt= max(nearBead(:)); % Normalizing factor
        %fprintf('File renormalized with max= %3.0f... ', maxInt);
        myStack= myStack/ maxInt;
        fprintf('Done!\n');
        
        % Find Z slice with highest focus
        %[~,maxZ]=max(integralImage); % Central slice
        %fprintf('Max Z at slice %d\n', maxZ);        
        % Now create a single stack adding the individual files and align
        % them
        for iSlice=1: zSize
            %myPSF= myPSF + myStack; % <- This is wrong. I need to align them along Z.
            myPSF(:, :,  zSize -maxZ(iFile) +iSlice)= myPSF(:, :,  zSize -maxZ(iFile) +iSlice) + myStack(:, :, iSlice);
        end
    end
    
    % Remove slices that are completely dark.
    removeThese=[];
    for iSlice=1: 2*zSize
       PSFslice= (myPSF(:,:,iSlice) );
       if(mean(PSFslice(:))==0)
           removeThese= [removeThese iSlice];
       end
    end
    myPSF(:,:,removeThese)= [];
    
    myPSF= myPSF*64000;
    myPSF= myPSF / nFiles;
    myPSF= uint16(myPSF);
    
    % Write the whole PSF image
    TIFF_writeStack(myPSF, [imageFolder '\myPSF.tif']);
    
    % Now write a subset of it (after we have a look)
    zCenter= 33;
    zDelta= 18;
    windowsSize= 40;
    realPSF= myPSF(ySize/2-windowsSize:ySize/2+windowsSize, xSize/2-windowsSize-1:xSize/2+windowsSize-1, zCenter-zDelta:zCenter+zDelta);
    
    % Do we use circular simmetry?
    
    % Write the "real" PSF
    TIFF_writeStack(realPSF, [imageFolder 'global\myPSF_small.tif']);
    

end

