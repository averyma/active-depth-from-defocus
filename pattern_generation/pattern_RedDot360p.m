clc
clear
close all

%% poisson disc sampling approach
proj_rez = [360 640];
dot_density = 0.40*0.01;
numb_dots = round(proj_rez(1)*proj_rez(2)*dot_density);

% use pdisk2 function to generate dot coooridnates and round it to integers
dot_location = ceil(pdisk2(proj_rez, numb_dots));

% convert coordinate to index locations
dot_index = sub2ind(proj_rez,dot_location(:,1),dot_location(:,2));

dot_pattern = zeros(proj_rez);
dot_pattern(dot_index) = 1;

se = strel('square',1) ;
dot_pattern = imdilate(dot_pattern,se);

dot_zero = zeros(proj_rez(1),proj_rez(2),3);
color = 1;
dot_zero(:,:,color) = dot_pattern;
dot_pattern = dot_zero;


% limiting to center part only
% w = 20;
% dot_pattern(:,1:w,:)=0;
% dot_pattern(:,(end-w+1):end,:)=0;
% h = 50;
% dot_pattern(1:h,:,:)=0;
% dot_pattern((end-h+1):end,:,:)=0;

figure(1), imshow(dot_pattern)
imwrite(dot_pattern,'cnn_r_040_360p.png')

% creating 3 shifted version:
% dot_pattern = repmat([0 0 0 0 0; 0 0 1 0 0; 0 0 0 0 0], [1 1 3]);
dot_pattern_h = dot_pattern;
dot_pattern_h(:,1,:) = [];
dot_pattern_h = [dot_pattern_h zeros(size(dot_pattern_h,1),1,3)];

dot_pattern_v = dot_pattern;
dot_pattern_v(1,:,:) = [];
dot_pattern_v = [dot_pattern_v; zeros(1,size(dot_pattern_h,2),3)];

dot_pattern_vh = dot_pattern_v;
dot_pattern_vh(:,1,:) = [];
dot_pattern_vh = [dot_pattern_vh zeros(size(dot_pattern_h,1),1,3)];

imwrite(dot_pattern,'cnn_r_100_1.png')
imwrite(dot_pattern_v,'cnn_r_100_2.png')
imwrite(dot_pattern_h,'cnn_r_100_3.png')
imwrite(dot_pattern_vh,'cnn_r_100_4.png')
