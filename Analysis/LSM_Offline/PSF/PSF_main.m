function [ output_args ] = PSF_main( input_args )
 %% PSF_MAIN This function will produce individual PSF stacks
 %  The coordinate of the beads are obtained from IMAGEJ. The first bead is
 %  always a blank area and is used to calculate the noise on the image and
 %  subtract it.
 %  The bead files are then saved in the output folder specified in
 %  PSF_extractPSF.m.
 
    beadFile= 'S:\LiSM data\160805 PSF\A\coord.txt';
    beads= readBeadFile_imgj(beadFile);
    
    imgFile= 'S:\LiSM data\160805 PSF\A\images.tif';
    myStack= TIFF_read(imgFile);
    
  % EXTRACT NOISE INFO (remove that bead from array)
    noiseSize= 10;
    [noiseAvg, noiseStd] = PSF_getStackNoise(myStack, beads(1,1), beads(1,2), noiseSize);
    fprintf('Noise avg= %f, Noise std= %f, window= %d\n', noiseAvg, noiseStd, noiseSize);
    beads(1, :)= [];
    
  % SUBTRACT AVG NOISE
    myStack= myStack - noiseAvg;

  % FIND CENTER OF BEAD
    [nBeads, ~]= size(beads);
    for iBead=1: nBeads
        %iBead= 2;
        [Xpos, Ypos]= PSF_findCenter(myStack, beads(iBead,2), beads(iBead,1));
    
    
      % EXTRACT BEAD SUBIMG
        %Do we center the PSF on the bead or do we take its average position?
        %Maybe average is better, since it will show the "movement".
        meanXpos= mean(Xpos(Xpos~=0));
        meanYpos= mean(Ypos(Ypos~=0));
        fprintf('Mean X pos= %3.1f, Mean Y pos= %3.1f\n', meanXpos, meanYpos);
        PSF_extractPSF(myStack, iBead, meanYpos, meanXpos);
        %sub=PSF_extractBead(myStack, beads(1,1), beads(1,2), 40);
        %TIFF_writeStack(sub, 'D:\LSM_Data\160512_PSF_S.tif');
    end
  
    
end

