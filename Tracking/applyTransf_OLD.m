function [ transfImg ] = applyTransf_OLD( A, img)
%% Apply transformation to image
% The matrix A defines affine transformation. For instance
% A= [1 0 0 0; 0 1 0 0; 0 0 1 0; 10 0 4 1]
%
%      1     0     0     0
%      0     1     0     0
%      0     0     1     0
%     10    50     4     1
%
%results in a shift up by 10 pixels, left by 50 pixels and a shift of 4
% stacks (the first 4 are discarded, 4 empty slides appended at the end).


	[w, h, depth] = size(img);
    transfImg = zeros(w, h, depth, 'uint16');
    
	xo = -0.5*w;
	yo = -0.5*h;
	zo = -0.5*depth;

    z = zo;
	p = 1;
    for zi= 1:depth
	%for (zi = 0, z = zo; zi < depth; zi++, z+=1.0)
        y = yo;
        for yi = 1:h
        %for (yi = 0, y = yo; yi < h; yi++, y+=1.0) 
            x = xo;
            for xi = 1:w
            %for (xi = 0, x = xo; xi < w; xi++, x+=1.0, p++) 
                xp = round(x*A(1,1) + y*A(2,1) + z*A(3,1) + A(4,1) - xo +1);
				yp = round(x*A(1,2) + y*A(2,2) + z*A(3,2) + A(4,2) - yo +1);
				zp = round(x*A(1,3) + y*A(2,3) + z*A(3,3) + A(4,3) - zo +1);
				
%                 text= ['xp ' num2str(xp) ';yp ' num2str(yp) '; zp ' num2str(zp)];
%                 disp(text);
                if ((xp >= 1) && (xp <= w) && (yp >= 1) && (yp <= h) && (zp >= 1) && (zp <= depth))
                    transfImg(p) = img(xp, yp, zp);
                end
                x = x+1;
                p = p+1;
                
            end
            y= y+1;
        end
        z= z+1;
    end
end