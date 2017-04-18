function [ FinalImage ] = TIFF_read( inFile )
%TIFF_READ Open the file, reads all the images within then closes the file.
 
    
    if exist(inFile, 'file')
        myTiff = Tiff(inFile, 'r');

        InfoImage=imfinfo(inFile);
        mImage=InfoImage(1).Width;
        nImage=InfoImage(1).Height;
        NumberImages=length(InfoImage);
        FinalImage=zeros(nImage, mImage, NumberImages, 'uint16');
        
        %numStrips = numberOfStrips(myTiff);

        for i= 1: NumberImages
            myTiff.setDirectory(i);
            %disp('LAST DIR?');
            %tf = lastDirectory(myTiff)
            FinalImage(:,:,i)= myTiff.read();
        end
        %image(FinalImage);
        myTiff.close();
    else
        FinalImage=zeros(0, 0, 0, 'uint16');
        errorMessage = sprintf('File %s not found\n%s', inFile);
        error(errorMessage);
    end
end

