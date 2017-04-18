function [ ROI_img ] = tr_extractROI_abs( img, ROI )
%% TR_EXTRACTROI Returns a subset of the original image
%  img is the original image
%  ROI is a 6 component array [xstart, xstop, ystart, ystop, zstart, zstop]
%  with each component expressed in absolute pixel values.

    if (numel(ROI) ~= 6)
        myError = 'ROI needs to contain 6 elements';
        error(myError);
    else
        if ((ROI(1) >= ROI(2)) || (ROI(3) >= ROI(4)) || (ROI(5) >= ROI(6)) )
            myError = 'Check that start position is before stop position';
            error(myError);
        end
        
        ROI_img= img( ROI(1): ROI(2), ROI(3): ROI(4), ROI(5): ROI(6)); 
        myMsg=('ROI extraction done!');
        disp(myMsg);
    end
end

