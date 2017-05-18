function [ ROI_img ] = tr_extractROI( img, ROI )
%%  TR_EXTRACTROI Returns a subset of the original image (using relative positions)
%   img is the original image
%   ROI is a 6 component array [xstart, xstop, ystart, ystop, zstart, zstop]
%   with each component comprised between 0 and 1, with 0 indicating the
%   first position in the dimension, 1 indicating the last position. To
%   return the full image type [0, 1, 0, 1, 0, 1]

%   Sanity checks on passed values
    if (numel(ROI) ~= 6)
        myError = 'ROI needs to contain 6 elements';
        error(myError);
    else
        if ((ROI(1) >= ROI(2)) || (ROI(3) >= ROI(4)) || (ROI(5) >= ROI(6)) )
            myError = 'Check that start position is before stop position';
            error(myError);
        end
        for i= 1:6
            if (ROI(i) <0) || (ROI(i)>1)
                myError = 'ROI positions should be comprised between 0 and 1.';
                error(myError);
            end
        end
        originalSize= size(img);
    %   Calculate pixel coordinates of ROI
        ROI_pixel= [ floor(originalSize(1)*ROI(1))+1, floor(originalSize(1)*ROI(2)), floor(originalSize(2)*ROI(3))+1, floor(originalSize(2)*ROI(4)), floor(originalSize(3)*ROI(5))+1, floor(originalSize(3)*ROI(6))];
    %   Extract ROI   
        fprintf('Extracting ROI: X(%d : %d), Y(%d : %d), Z(%d : %d) ... ', ROI_pixel(1), ROI_pixel(2), ROI_pixel(3), ROI_pixel(4), ROI_pixel(5), ROI_pixel(6) );
        ROI_img= img( ROI_pixel(1): ROI_pixel(2), ROI_pixel(3): ROI_pixel(4), ROI_pixel(5): ROI_pixel(6)); 
        fprintf('Done!\n');
    end
end

