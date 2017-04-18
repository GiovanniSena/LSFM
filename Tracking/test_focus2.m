 % LOAD IMAGES
    %inFile = 'D:\Images\Test\focus_2_blur.tif';
    
    for x= 1: 500
        for y= 1: 500
         if x<100   
            focus_1(y, x)= int16(0);
         elseif (x>100) && (x<=200)
            focus_1(y, x)= int16(50);     
         elseif (x>200) && (x<=300)
            focus_1(y, x)= int16(100);     
         elseif (x>300) && (x<=400)
            focus_1(y, x)= int16(150);
         elseif (x>400) 
            focus_1(y, x)= int16(200); 
         end
         
         if x==y && x<500 && x>1
             focus_1(y, x)= int16(255);
             focus_1(y, x+1)= int16(255);
             focus_1(y, x-1)= int16(255);
         end
         
        end
    end
    
    TIFF_write(focus_1, 'D:\Images\Test\myTest_1.tif');
    
    focus_2 = imgaussfilt(focus_1, 2);
    TIFF_write(focus_2, 'D:\Images\Test\myTest_2.tif');
    
    focus_3= focus_2;
    for i= 1:20
    focus_3 = imgaussfilt(focus_3, 2);
    end
    TIFF_write(focus_3, 'D:\Images\Test\myTest_3.tif');
    

    %[width, height, depth]= size(InitialStack);

    tic
 % FIND FOCUS VALUE
    method= 'WAVR';
    fmeasure(focus_1, method, [])
    fmeasure(focus_2, method, [])
    fmeasure(focus_3, method, [])
    
    % GRAT works nicely
    % GRAS also ok
    % LAPE ok
    % LAPV ok
    % LAPD works well
    % SFQR good
    % WAVS good
    
    
    
    disp('ELAPSED')
    disp(toc)

