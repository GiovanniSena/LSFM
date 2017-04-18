function [ output_args ] = OpenFile_test( input_args )
%OPENFILE_TEST Summary of this function goes here
%   Detailed explanation goes here
    %A = imread('D:\Images\Test\testImg_1.tiff');
    %B = imread('D:\Images\Test\testImg_2.tiff');
    %imshow(A, [0,4095] );
    
    inFile = 'D:\Images\Test\testWriteTiff_redone.tif';
    %inFile = 'D:\Images\Test\WellDone.tif';
    myTiff = Tiff(inFile, 'r');

    InfoImage=imfinfo(inFile);
    mImage=InfoImage(1).Width;
    nImage=InfoImage(1).Height;
    NumberImages=length(InfoImage);
    FinalImage=zeros(nImage, mImage, NumberImages, 'uint16');
    %offsets = myTiff.getTag('SubIFD');
    
    disp('STRIPS');
    numStrips = numberOfStrips(myTiff);

    i=1;
    tic;
    nImages= 1;
    for i= 1: NumberImages
        myTiff.setDirectory(i);
        %disp('LAST DIR?');
        %tf = lastDirectory(myTiff)
        myTiff.getTag('DateTime')
        FinalImage(:,:,i)= myTiff.read();
        %pause(0.5);
    end
    disp('NUMBER');
    disp(nImages);
    size(FinalImage)
    
    for i=1: NumberImages
        imagesc(FinalImage(:, :, i));
        colormap(gray);
        disp(i);
        pause(1);
    end
    
    
    
     
%     InfoImage=imfinfo(inFile);
%     mImage=InfoImage(1).Width;
%     nImage=InfoImage(1).Height;
%     NumberImages=length(InfoImage);
    
%     myTags = myTiff.getTag();
%     
%     myTiff.setSubDirectory(offsets(1));
%     
%     subimage_one = myTiff.read();
%     
%     imagesc(subimage_one)
%     
%     myTiff.setSubDirectory(offsets(2));
%     
%     subimage_two = myTiff.read();
%     
%     imagesc(subimage_two)
%     
    myTiff.close();
    
end

