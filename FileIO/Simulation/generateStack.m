function [ output_args ] = generateStack( input_args )
 %% GENERATESTACK Create a TIFF file simulating the beads
 %   

    imgH= 1040;
    imgW= 1392;
    imgD= 240;
    spacing= 4;
    nStacks = imgD/spacing;
    nBeads= 100;
    
    gaussKernel= 7;

 % CREATE THE VOLUME
    volumeImg= zeros(imgW, imgH, imgD, 'uint16');
     
 % GENERATE nBeads WHITE SPOTS IN THE VOLUME
    disp('GENERATE RANDOM BEADS');
    for i= 1 : nBeads
        randX= randi(imgW);
        randY= randi(imgH);
        randZ= randi(imgD);
        
        volumeImg(randX, randY, randZ) = uint16(4095);
       
    end
    disp('APPLY GAUSS FILTER');
    smoothImg= uint16(smooth3(volumeImg, 'gaussian', gaussKernel));
    disp('SAVE TO FILE');
    for(i= 1:nStacks)
        TIFF_write(smoothImg(:, :, 1+(i-1)*spacing), 'D:\Images\Test\testBeads.tiff');
    end
    disp('DONE');
end

