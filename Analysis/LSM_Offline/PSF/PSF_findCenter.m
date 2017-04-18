function [ Xpos, Ypos ] = PSF_findCenter( myStack, beadX, beadY )
 %% PSF_FINDCENTER Summary of this function goes here
 %  Detailed explanation goes here
    
    myFolder= 'D:\LSM_Data\';
    myFile= 'fitResults.txt';
    
    fileID= fopen([myFolder myFile], 'a+');
    
    
    searchSize= 50;
    [sizeY, sizeX, sizeZ]=size(myStack);
    myStack= double(myStack);
    Ypos= zeros(sizeZ,1);
    Xpos= zeros(sizeZ,1);
    %fprintf(fileID, '======================================\n');
    fprintf(fileID, '**************** FITTING BEAD (%d, %d) ****************\n', beadX, beadX);
    for iStack= 1: sizeZ
        myImage= myStack(:, :, iStack);
        subImage=PSF_extractBead(myImage, beadX, beadY, searchSize);
        %image(subImage)
        [x,y]=meshgrid(1:searchSize+1, 1:searchSize+1);
        x=x(:);
        y=y(:);
        z=subImage(:);
        %cftool(x, y, z);
        fprintf('FITTING SLICE %d OF %d\n', iStack, sizeZ);
        fprintf(fileID, 'FIT RESULTS FOR SLICE %d OF %d\n', iStack, sizeZ);
        [fitresult, ~]=PSF_createGaussFit(x, y, z, searchSize);
        PSF_printFitResults(fileID, fitresult);
        %fitresult
        plot(fitresult, [x,y],z);
        if (fitresult.a1 > 20)
            Ypos(iStack)=  (fitresult.y0+ beadX-searchSize/2-1); %X in imagej
            Xpos(iStack)=  (fitresult.x0+ beadY-searchSize/2-1); %Y in imagej
        end
    end
    fclose(fileID);
    %[Xpos, Ypos];
    
    
end

