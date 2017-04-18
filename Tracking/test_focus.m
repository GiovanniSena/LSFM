    %CamPos= [22.4596 22.4586 22.4576 22.4567 22.4557 22.4547 22.4607 22.4617 22.4627 22.4636 22.4646 22.4656 22.4666];
    

 % ROI
    af_x=  0.5;
    af_y=  0.3;
    af_w=  0.4;
    af_h=  0.4;

 % LOAD IMAGES
    inFile = 'D:\LSM_Data\150804_focusandtrack\150812_testFocus7.tif';
    focus_stack= TIFF_read(inFile);
    [yDim, xDim, nsamples]= size(focus_stack);

 % EXTRACT ROI   
    afx_i= round(xDim*af_x+1); %THIS IS CORRECT: what I call X in preview is Y in saved image
    afx_f= round(xDim*(af_x + af_w));
    afy_i= round(yDim*af_y+1);
    afy_f= round(yDim*(af_y+ af_h));
    
    focus_stack_ROI = focus_stack(afy_i:afy_f, afx_i:afx_f, : );
    
    %TIFF_writeStack(focus_stack_ROI, 'D:\LSM_Data\150804_focusandtrack\150804_toFocus_ROI.tif');
 
 % ADJUST CONTRAST
    for iSlice=1: nsamples
        focus_stack_ROI_ADJ(:,:, iSlice) = imadjust(focus_stack_ROI(:,:,iSlice));
    end
    %TIFF_writeStack(focus_stack_ROI_ADJ, 'D:\LSM_Data\150804_focusandtrack\150804_toFocus_ROI_ADJ.tif');
    
    tic
 % FIND FOCUS VALUE
    sharpVal= zeros(nsamples, 1);
    
    measure= 'HISE';
    for iSlice=1: nsamples
        %myPicture= focus_stack_ROI(:,:, iSlice);
        myPicture= focus_stack(:,:, iSlice);
        sharpVal(iSlice)= fmeasure(myPicture, measure, []);
        fprintf('IMAGE %d, SHARPNESS= %3.2f\n', iSlice, sharpVal(iSlice));
    end
    [maxS, posS]= max(sharpVal);
    fprintf('MAX= %f, POS= %d\n', maxS, posS);
    sharpVal= sharpVal./maxS;
    
% PLOT
    %plot(CamPos, sharpVal,  'o');
    plot( sharpVal,  'o');
    title(measure);
    
    fid= fopen('D:\LSM_Data\150804_focusandtrack\results.txt', 'a');
    fprintf(fid, '%s\t', measure);
    for i= 1:nsamples-1
        fprintf(fid, '%f\t', sharpVal(i));
    end
    fprintf(fid, '%f\n', sharpVal(end));
    fclose(fid);
    
    disp('ELAPSED')
    disp(toc)

