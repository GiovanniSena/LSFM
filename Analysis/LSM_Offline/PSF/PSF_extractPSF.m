function [ output_args ] = PSF_extractPSF( myStack, iBead, meanXpos, meanYpos)
 %% PSF_EXTRACTPSF Summary of this function goes here
 %  Detailed explanation goes here
    
    fprintf('Extracting PSF from X= %3.1f, Y= %3.1f\n', meanXpos, meanYpos);
    saveFolder= 'S:\LiSM data\160805 PSF\A\';
    
	[sizeY, sizeX, sizeZ]=size(myStack);
    maxRadius= 20; %This determines the size of the output file, in pixels.
    % Check that the bead is not too close to the edge
    yMin=meanYpos-maxRadius;
    yMax=meanYpos+maxRadius;
    xMin=meanXpos-maxRadius;
    xMax=meanXpos+maxRadius;
    if ((yMax < sizeY) && (yMin > 1) && (xMax < sizeX) && (xMin >1))
        %for iStack= 1: sizeZ
        subStack= myStack(yMin:yMax, xMin:xMax, :);
        %end
        % Save to file
        TIFF_writeStack(subStack, [saveFolder 'Bead_1_' num2str(iBead) '.tif']);
    else
        fprintf('Bead too close to the edge. Skipping\n');
    end
    


end

