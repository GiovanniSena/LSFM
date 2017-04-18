function [ L2 ] = calcL2_OLD(i1, i2, x1, x2, y1, y2, z1, z2)
%% Pixel by pixel comparison
% If two images are identical should return 0. Larger values indicate large
% difference in images.

	%double ret;
	%double tot;
	%double d;
	
    %int x, y, z, p;
    %[w, h, depth] = size(i1);
	
	ret = 0.0;
    tot = 0.0;
	
    for z= z1:z2
        for y= y1:y2
            for x= x1:x2
                if ((i1(x,y,z) ~= 0) && (i2(x,y,z) ~= 0)) 
					d = double(i1(x,y,z) - i2(x,y,z));
                    %disp(num2str(d));
					ret = ret + d*d;
					tot = tot + 1.0;
                end
            end
        end
    end
	L2=  sqrt(ret/tot);
end