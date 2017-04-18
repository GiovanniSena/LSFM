function PlotScan()
    
    dataDir= 'D:\LSM_Data\260515_scanLong\';
    logDir= 'D:\LSM_Data\260515_scanLong\';
    
 % DEFINE ROI    
    xstart= 750;
    xstop= 781;
    ystart= 520;
    ystop= 550;
    legendArray= [];
    for fileN= 1:50 %SCAN OVER FILES
        fileName= ['260515_scanLong_' num2str(fileN, '%03d') '.tif'];
        myStack=TIFF_read([dataDir fileName]);

        [ydim, xdim, imgPerStack ]= size(myStack); %#ok<ASGLU>
        %imgPerStack=1; 
        maxValArray= zeros(imgPerStack, 1);
        SyValArray= zeros(imgPerStack, 1);
        Sy_0= 11.6180;
        SySpacing= 0.0010;
        legendArray= [legendArray + '1'];
        for i= 1:imgPerStack %SCAN OVER IMAGES IN FILE
%              z=image(myStack(ystart:ystop, xstart:xstop, i));
%              colormap(gray);
%              pause(0.1);
            zSet= single(myStack(ystart:ystop, xstart:xstop, i));
            %histogram(zSet(:));
            %histfit(zSet(:));
            maxValArray(i)= max(zSet(:));
            SyValArray(i)= Sy_0 - SySpacing*(i-1);
            disp(['Slice ' num2str(i) '\' num2str(imgPerStack) '; Sy= ' num2str(SyValArray(i)) '; maxVal= ' num2str(maxValArray(i))]);
        end
        plot(SyValArray, maxValArray);
        hold on;
        
    end
    legend(legendArray);

end