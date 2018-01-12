clc
clear
close all

root_dir = '/Users/ama/Desktop/DfD/ScreenCap/cnn/20170725ScreenCap/normalization/';
b1 = im2double(imread([root_dir 'b_50_b1.png']));
b2 = im2double(imread([root_dir 'b_50_b2.png']));
b3 = im2double(imread([root_dir 'b_50_b3.png']));
b4 = im2double(imread([root_dir 'b_50_b4.png']));
b5 = im2double(imread([root_dir 'b_50_b5.png']));
b = (b1+b2+b3+b4+b5)./5;

figure;imshow(b);
rect = getrect;
b = b(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3),3);

b_1080p = imresize(b,[1080,1920],'lanczos3');
b_1080p_norm = b_1080p./max(b_1080p(:));

% r50_norm = (r50-r50_min)./(r50_max-r50_min).*(1-0)+0;
% figure;imshow(r50_norm)
% r60_norm = (r60-r60_min)./(r60_max-r60_min).*(1-0)+0;

%% correct cnn pattern
pattern = im2double(imread([root_dir 'cnn_b_org.png']));
p = pattern(:,:,3);
p = p./b_1080p_norm;
p = p./max(p(:));
% p = (p-min(p(:)))./(max(p(:))-min(p(:))).*(0.1-0)+0;
pattern(:,:,3) = p;
imwrite(pattern,[root_dir 'cnn_b_itr1.png'])

%% correct flat norm pattern
norm = im2double(imread([root_dir 'norm_b_org.png']));
n = norm(:,:,3);
n = n./b_1080p_norm;
n = n./max(n(:))./10;
norm(:,:,3) = n;

imwrite(norm,[root_dir 'norm_b_itr1.png'])




