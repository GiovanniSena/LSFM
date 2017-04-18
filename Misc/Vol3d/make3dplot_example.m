% figure(1);
% 
% DATA1 = load('slice_1.txt');
% 
% for i = 2: 50
% 	istr = int2str(i);
% 	name = ['slice_',istr,'.txt'];
%     
%     data_tmp = load(name);
%     DATA1(:,:,i) = data_tmp;
%     
% end

    inFile = 'D:\Images\NY_images\raw_exp1_sc53.tif';
    InitialImage= TIFF_read(inFile);
vol1 = vol3d('cdata',InitialImage,'texture','3D');

alphamap('rampup');
alphamap(0.1 .* alphamap);
vol3dtool();