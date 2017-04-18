stackImg = zeros(60, 60, 60, 'uint16');

for i= 1:60 %Horizontal line
   stackImg(30, i, 30) = 4096;
   stackImg(29, i, 30) = 2048;
   stackImg(31, i, 30) = 2048;
   stackImg(28, i, 30) = 1024;
   stackImg(32, i, 30) = 1024;
end

for i= 15:45 %Vertical line on right side
   stackImg(i, 45, 30) = 4096; 
end

   stackImg(30,10,30) = 4096;
   
for i= 1:360
    rads= i*3.14/360;
    third= round(cos(rads)*15)+30;
    first= round(sin(rads)*15)+30;
    stackImg(first, 10, third) = 4096;
end

TIFF_writeStack(stackImg, 'D:\Images\NY_images\sample.tif');
