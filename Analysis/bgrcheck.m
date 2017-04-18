function [ T, BW, BWf, ttl_area ] = bgrcheck( myPicture )
%% bgrcheck calculates the area of objects extracted from raw image, to check if there is a root there or not.
T=adaptthresh(myPicture, 0.05); % The second parameter is the sensitivity. 
                                % The higher the sensitivity, the more likely 
                                % that pixels will be included as
                                % foreground. The default is 0.5, which did
                                % not work well in tests.
BW=imbinarize(myPicture, T);
BWf=bwareafilt(BW,5);
ttl_area=sum(BWf(:));
end