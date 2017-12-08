clc
clear
close all

iptsetpref('ImshowBorder','tight')

%% dot/dot-grid pattern
dot_radius = 2;
pad_size = 10;

dot = ones(1);
% dot = fspecial('disk',dot_radius);
% dot(dot>0) = 1;

% dot = fspecial('gaussian',[9 9],0.5); dot=dot./max(dot(:));
% 
% dot = [0 0 0 1 0 0 0;
%        0 1 0 1 0 1 0;
%        0 0 1 1 1 0 0;
%        1 1 1 1 1 1 1;
%        0 0 1 1 1 0 0;
%        0 1 0 1 0 1 0;
%        0 0 0 1 0 0 0;];


dot_size = size(dot,1);
dot_patch = zeros(dot_size + 2*pad_size);
dot_patch(pad_size+1:pad_size+dot_size,pad_size+1:pad_size+dot_size) = dot;
dot_patch_size = size(dot_patch,1);
% figure,imshow(dot_patch)


% grid_width = 1;
% dot_patch((dot_patch_size+1)/2-grid_width:(dot_patch_size+1)/2+grid_width,1:end) = 1;
% dot_patch(1:end,(dot_patch_size+1)/2-grid_width:(dot_patch_size+1)/2+grid_width) = 1;

proj_rez = [1080 1920];
% proj_rez = [360 640];

dot_pattern = repmat(dot_patch, ...
                    round((proj_rez(1) + dot_patch_size)/dot_patch_size),...
                    round((proj_rez(2) + dot_patch_size)/dot_patch_size));

dot_pattern = dot_pattern(1:proj_rez(1),1:proj_rez(2));
dot_zero = zeros(1080,1920,3);
color = 3;
dot_zero(:,:,color) = dot_pattern;
dot_pattern = dot_zero;

figure(1), imshow(dot_pattern)
% set(1,'menubar','none')
% set(1,'position',[2300 0 size(dot_pattern,2) size(dot_pattern,1)]);

