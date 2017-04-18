function Tiff_test3D( outFile )
    %% Write 3D stack
        
        width= 1040;
        height= 1392;
        slices= 16;
        imgdata = zeros(width, height, slices, 'uint16');
        
        for i= 1 : height 
            for j= 1: width
                for k= 1: slices
                tmp= j*i*k;
                
                imgdata(i, j, k) = tmp/22;
                end
            end
        end
        imgSize = size(imgdata);
        disp(num2str(imgSize));

        
        TIFF_writeStack(imgdata, 'D:\Images\Test\3DStack.tiff');

end

