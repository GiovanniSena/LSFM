function [ FinalImage ] = TIFF_read( inFile )
%%  TIFF_READ Open a TIFF file, read all the images within then close the file.
%   The read image is returned in a matrix where each element is the
%   intensity of the corresponding pixel.
 
    if exist(inFile, 'file')
        myTiff = Tiff(inFile, 'r');
        InfoImage=imfinfo(inFile);
        mImage=InfoImage(1).Width;
        nImage=InfoImage(1).Height;
        NumberImages=length(InfoImage);
        FinalImage=zeros(nImage, mImage, NumberImages, 'uint16');
        for i= 1: NumberImages
            myTiff.setDirectory(i);
            FinalImage(:,:,i)= myTiff.read();
        end
        myTiff.close();
    else
        FinalImage=zeros(0, 0, 0, 'uint16');
        errorMessage = sprintf('File %s not found\n%s', inFile);
        error(errorMessage);
    end
end

