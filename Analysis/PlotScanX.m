function PlotScan()
    
    dataDir= 'D:\LSM_Data\';
    logDir= 'D:\LSM_Data\Logs\';
    
 % DEFINE ROI    
    xstart= 720;
    xstop= 780;
    ystart= 505;
    ystop= 580;
    legendArray= [];
    totFileN= 150;
    
    maxValArray= zeros(totFileN, 1);
    SxValArray= zeros(totFileN, 1);
    Cx_0= 18.5751;
    CxSpacing= 0.0010;
    for fileN= 1:totFileN %SCAN OVER FILES
        fileName= ['220518_C9_scanXlong2_' num2str(fileN, '%03d') '.tif'];
        myStack=TIFF_read([dataDir fileName]);

        [ydim, xdim, imgPerStack ]= size(myStack); %#ok<ASGLU>
        %imgPerStack=1; 
        
        legendArray= [legendArray + '1'];
        for i= 1:imgPerStack %SCAN OVER IMAGES IN FILE
%              z=image(myStack(ystart:ystop, xstart:xstop, i));
%              colormap(gray);
%              pause(0.1);
            zSet= single(myStack(ystart:ystop, xstart:xstop, i));
            %histogram(zSet(:));
            %histfit(zSet(:));
            maxValArray(fileN)= max(zSet(:));
            SxValArray(fileN)= Cx_0 - CxSpacing*(fileN-1);
            disp(['Slice ' num2str(fileN) '\' num2str(totFileN) '; Sx= ' num2str(SxValArray(fileN)) '; maxVal= ' num2str(maxValArray(fileN))]);
        end
       
        %hold on;
        
    end
    plot(SxValArray, maxValArray);
    title('220515\_C9\_scanXlong; F= 21.3308');
    xlabel('Cx position (mm)');
    ylabel('Intensity [a.u.]');
    %legend(legendArray);

end