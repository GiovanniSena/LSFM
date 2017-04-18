function ScanSingleFileBeadss()
 %% Analyze images and plots intensity of beads vs position
 %  The bead located near (beadX, beadY) but note that the image is rotated
 %  90 degrees (so if you use imagej, you have to swap X and Y).
    
    my3dData= [];
    xMaxArray= [];
    yMaxArray= [];
    
 
 % CREATE FIGURE
    myFigure= figure('Position', [193 141 1531 837]);
    ax1= subplot(2, 2, 1);
    ax2= subplot(2, 2, 2);
    ax3= subplot(2, 2, 3);
    ax4= subplot(2, 2, 4);
    
    xlabel(ax1, 'Y position camera');
    ylabel(ax1, 'Average bead intensity');
    xlabel(ax2, 'X position camera');
    ylabel(ax2, 'Y position camera');
    zlabel(ax2, 'Average bead intensity');
    
 % USER PARAMETERS   
    dataDir= 'D:\LSM_Data\020615_manualScan\';
    logDir= 'D:\LSM_Data\020615_manualScan\';
    logFileName= '020615_manualScan.txt';
    
    %fileName= '020615_manualScan_001.tif';
    %beadX= 777; % Approximate X position of bead (Y coordinate in ImageJ)
    %beadY= 818; % Approximate Y position of bead (X coordinate in ImageJ)  
    boxSize= 25; % Size of search box around (beadX, beadY) to find maximum
    radius= 5; % Radius, in pixels, used to average around the maximum
    
 % READ SCAN FILE
    dataMatrix= readLogFile([logDir logFileName]);
    [numberOfFiles, ~] =size(dataMatrix{1});
    xPositionArray= zeros(numberOfFiles, 1);
    %numberOfFiles= 6;
    
    beadXvec= [9 41	41 172 420 373 656 957];
    beadYvec= [805	685	1236 829 649 1121 702 1290];
    [~, numberOfBeads]= size(beadXvec);
    numberOfBeads=1;
    
   %SCAN OVER FILES
    for fileN= 1:numberOfFiles
        
        fileName=strrep(dataMatrix{1}{fileN}, ';',''); % REMOVE ";" AT THE END OF FILE NAME
        myStack=TIFF_read([dataDir fileName]); % READ IMAGE FILE
        [ydim, xdim, imgPerStack ]= size(myStack); %#ok<ASGLU>
        disp(['ANALYZING FILE: ' fileName]);
        
        camXPos= dataMatrix{5}(1);
        xPositionArray(fileN)= camXPos;
        intensityArray= zeros(imgPerStack, 1);
        yPositionArray= zeros(imgPerStack, 1);
        
       %SCAN OVER IMAGES IN FILE 
        for i= 1:imgPerStack 
        %for i= 1:1      
        
        %for beadN= 1:numberOfBeads
        %beadX= beadXvec(beadN);
        %beadY= beadYvec(beadN);
            camYPos= dataMatrix{6}(1) - dataMatrix{7}(1)*(i-1);
            currentFrame= myStack(:,:,i);
            
            [averageInt, stDevint, maxCol, maxRow]=averagePixelsCircle(currentFrame, beadX, beadY, boxSize, radius);
            %pause(0.5);
            intensityArray(i)= averageInt;
            yPositionArray(i)= camYPos;
            xMaxArray((fileN-1)*imgPerStack+i)= maxCol;
            yMaxArray((fileN-1)*imgPerStack+i)= maxRow;
        end
        hold on;
        subplot(ax1);
        plot(ax1, yPositionArray, intensityArray );
        writeBeadstoFile([dataDir 'txt\' fileName], beadX, beadY, yPositionArray, intensityArray);
        hold off;
        
        
        disp(['BeadX= ' num2str(beadX) ' MAX= ' num2str(max(intensityArray))]);
        
        my3dData= cat(2, my3dData, intensityArray);
        
        
    end
    
    %surf(ax2, my3dData);
    
    %plot(ax3, xMaxArray);
    
    %plot(ax4, yMaxArray);
    
    
    h = rotate3d;
    h.Enable = 'on';
    setAllowAxesRotate(h,ax1,false); %Prevent 2d plot from rotation
    setAllowAxesRotate(h,ax3,false); %Prevent 2d plot from rotation
    setAllowAxesRotate(h,ax4,false); %Prevent 2d plot from rotation
    set(ax2, 'XTickLabel', num2str(xPositionArray));
    set(ax2, 'YTickLabel', num2str(yPositionArray));
    title(ax1, [logFileName 'Bead (' num2str(beadX) ',' num2str(beadY) '); Box=' num2str(boxSize) '; radius=' num2str(radius)], 'Interpreter', 'none');
end