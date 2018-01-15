% pdisk2_seq: take the result from pisk2 and create another list of dot
% locations that use r/2 as minimum distance
clc
clear
close all

%% poisson disc sampling approach
proj_rez = [1080 1920];
% proj_rez = [300 400];
dot_density = 0.70*0.01;
folder = 'C:\Users\avery\Desktop\DfD\pattern_seq\cnn_sequential_070b\';
numb_dots = round(proj_rez(1)*proj_rez(2)*dot_density);

% use pdisk2 function to generate dot coooridnates and round it to integers
dot_location_1 = pdisk2(proj_rez, numb_dots);
dot_location_2 = pdisk2_Sequential(proj_rez, dot_location_1);
% dot_location_2 = pdisk2_seq2(proj_rez, numb_dots, dot_location_1);

dot_location_1 = ceil(dot_location_1);
dot_location_2 = ceil(dot_location_2);

% convert coordinate to index locations
dot_index_1 = sub2ind(proj_rez,dot_location_1(:,1),dot_location_1(:,2));
dot_index_2 = sub2ind(proj_rez,dot_location_2(:,1),dot_location_2(:,2));

dot_pattern_1 = zeros(proj_rez);
dot_pattern_1(dot_index_1) = 1;

dot_pattern_2 = zeros(proj_rez);
dot_pattern_2(dot_index_2) = 1;

dot_zero = zeros(proj_rez(1),proj_rez(2),3);
dot_zero(:,:,1) = dot_pattern_1;
dot_zero(:,:,2) = dot_pattern_2;
dot_pattern = dot_zero;


%% limiting to center part only
w = 520;
dot_pattern(:,1:w,:)=0;
dot_pattern(:,(end-w+1):end,:)=0;
h= 50;
dot_pattern(1:h,:,:)=0;
dot_pattern((end-h+1):end,:,:)=0;

figure(1), imshow(dot_pattern)
imwrite(dot_pattern,[folder 'seq1_seq2_.png'])

dot_zero = zeros(proj_rez(1),proj_rez(2),3);
% dot_zero(:,:,1) = dot_pattern_1;
dot_zero(:,:,3) = dot_pattern_1;
dot_pattern = dot_zero;
w = 520;
dot_pattern(:,1:w,:)=0;
dot_pattern(:,(end-w+1):end,:)=0;
h = 50;
dot_pattern(1:h,:,:)=0;
dot_pattern((end-h+1):end,:,:)=0;

%% creating 3 shifted version:
dot_pattern_h = dot_pattern;
dot_pattern_h(:,1,:) = [];
dot_pattern_h = [dot_pattern_h zeros(size(dot_pattern_h,1),1,3)];

dot_pattern_v = dot_pattern;
dot_pattern_v(1,:,:) = [];
dot_pattern_v = [dot_pattern_v; zeros(1,size(dot_pattern_h,2),3)];

dot_pattern_vh = dot_pattern_v;
dot_pattern_vh(:,1,:) = [];
dot_pattern_vh = [dot_pattern_vh zeros(size(dot_pattern_h,1),1,3)];

imwrite(dot_pattern,[folder 'cnn_b_070_1.png'])
imwrite(dot_pattern_v,[folder 'cnn_b_070_2.png'])
imwrite(dot_pattern_h,[folder 'cnn_b_070_3.png'])
imwrite(dot_pattern_vh,[folder 'cnn_b_070_4.png'])

%% creating sequential version:
dot_zero = zeros(proj_rez(1),proj_rez(2),3);
dot_zero(:,:,3) = dot_pattern_2;
dot_pattern = dot_zero;
w = 520;
dot_pattern(:,1:w,:)=0;
dot_pattern(:,(end-w+1):end,:)=0;
h = 50;
dot_pattern(1:h,:,:)=0;
dot_pattern((end-h+1):end,:,:)=0;
imwrite(dot_pattern,[folder 'cnn_b_070_seq.png'])

