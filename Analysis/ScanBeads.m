function ScanBeads()
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
<<<<<<< .mine
    dataDir= 'D:\LSM_Data\280515\';
    logDir= 'D:\LSM_Data\280515\';
    logFileName= '280515_scanShort.txt';
=======
    dataDir= 'D:\LSM_Data\280515_scanShort\';
    logDir= 'D:\LSM_Data\280515_scanShort\';
    logFileName= '280515_scanShort.txt';
>>>>>>> .r106
    
    beadX= 580; % Approximate X position of bead (Y coordinate in ImageJ)
    beadY= 133; % Approximate Y position of bead (X coordinate in ImageJ)  
    boxSize= 100; % Size of search box around (beadX, beadY) to find maximum
    radius= 5; % Radius, in pixels, used to average around the maximum
    
 % READ SCAN FILE
    dataMatrix= readLogFile([logDir logFileName]);
    [numberOfFiles, ~] =size(dataMatrix{1});
    xPositionArray= zeros(numberOfFiles, 1);

    numberOfFiles= 3;
    
   %SCAN OVER FILES
    for fileN= 1:numberOfFiles
        %fileName= ['260515_scanLong_' num2str(fileN, '%03d') '.tif'];
        
        fileName=strrep(dataMatrix{1}{fileN}, ';',''); % REMOVE ";" AT THE END OF FILE NAME
        disp(['ANALYZING FILE: ' fileName]);
        
        myStack=TIFF_read([dataDir fileName]); % READ IMAGE FILE
        [ydim, xdim, imgPerStack ]= size(myStack); %#ok<ASGLU>
        
        camXPos= dataMatrix{5}(fileN);
        xPositionArray(fileN)= camXPos;
        intensityArray= zeros(imgPerStack, 1);
        yPositionArray= zeros(imgPerStack, 1);
        fileMax= 0;
        
       %SCAN OVER IMAGES IN FILE 
        for i= 1:imgPerStack 
            
            camYPos= dataMatrix{6}(fileN) - dataMatrix{7}(fileN)*(i-1);
            
            currentFrame= myStack(:,:,i);
            localMax= max(currentFrame(:));
            if (localMax > fileMax) && (localMax < 300)
                fileMax= localMax;
            end

            [averageInt, stDevint, maxCol, maxRow]=averagePixelsCircle(currentFrame, beadX, beadY, boxSize, radius);
            
            intensityArray(i)= averageInt;
            yPositionArray(i)= camYPos;
            xMaxArray((fileN-1)*imgPerStack+i)= maxCol;
            yMaxArray((fileN-1)*imgPerStack+i)= maxRow;
        end
        hold on;
        subplot(ax1);
        plot(ax1, yPositionArray, intensityArray );
        hold off;
        
        my3dData= cat(2, my3dData, intensityArray);
        
        disp(['File max= ' num2str(fileMax)]);
    end
    
    surf(ax2, my3dData);
    
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