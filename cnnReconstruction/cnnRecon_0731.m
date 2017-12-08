% close all
clc
clear

load('F:\DfD\ScreenCap\20170728ScreenCap\r\r_train234_raw\convnet_r_train234_raw.mat');
convnet_r = convnet;
load('F:\DfD\ScreenCap\20170728ScreenCap\b\b_train234_raw\convnet_b_train234_raw.mat');
convnet_b = convnet;
%%
root_dir = 'F:\DfD\ScreenCap\20170803ScreenCap\recon\';
object = 'hand_1';
patch_size = 20;
channel_threshold = 170;
rez = [2464 3280];
heat_map = zeros(rez);

%% r1
for cap = 1:2
    for seq = 1:2
        
    end
end
channel = 1;
folder_r = [root_dir object '\r\' ];
files = dir([folder_r '*.png']);
d1 = im2double(imread([folder_r files(3).name]));
d2 = im2double(imread([folder_r files(4).name]));
d3 = im2double(imread([folder_r files(5).name]));
f1 = im2double(imread([folder_r files(6).name]));
f2 = im2double(imread([folder_r files(7).name]));
f3 = im2double(imread([folder_r files(8).name]));
d = (d1+d2+d3)./3;
f = (f1+f2+f3)./3;

r = im2double(imread([folder_r files(1).name]));
img_ff = (r-d)./(f-d);
img = img_ff(:,:,channel);
img_threshold = img;
img_threshold(img_threshold(:,:)<(channel_threshold/255)) = 0;
lvl = graythresh(img_threshold);
img_otsu = img_threshold > lvl;
%     I_morph = imerode(I_threshold,strel('square',2));
img_stats = regionprops(img_otsu,'Centroid','Area');
area_thresh  = 5;
area_filter = [img_stats.Area]<area_thresh;
img_stats(area_filter) = [];
centroids = round(cat(1, img_stats.Centroid));
numb_of_dots = length(img_stats);
[n,m] = size(img(:,:,1));
[X,Y] = meshgrid(1:m,1:n);

sparse_map = zeros(numb_of_dots,3);

for i = 1:numb_of_dots
% outlier detection
    if (centroids(i,2)-patch_size/2-1)>0 && ...
       (centroids(i,2)+patch_size/2)<n && ...
       (centroids(i,1)-patch_size/2-1)>0 && ...
       (centroids(i,1)+patch_size/2)<m

        img_patch = img_ff(centroids(i,2)-patch_size/2+1:centroids(i,2)+patch_size/2,...
                            centroids(i,1)-patch_size/2+1:centroids(i,1)+patch_size/2,channel);
        img_patch = img_patch.*255;
        
        sparse_map(i,1:2) = centroids(i,1:2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%continuous depth label%%%%%%%%%%%%%%%%%%%%%%%%%%
%         scores = convnet_r.predict(I_patch);
%         depth = sum(scores'.*str2double(convnet_r.Layers(13,1).ClassNames));
%         sparse_map(i,3) = depth;
%%%%%%%%%%%%%%%%%%%%%%%%%%%discrete depth label%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        depth = classify(convnet_r,img_patch);
        sparse_map(i,3) = str2double(cellstr(depth));    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end
sparse_map_r1 = sparse_map;

%% r2
r = im2double(imread([folder_r files(2).name]));
img_ff = (r-d)./(f-d);
img = img_ff(:,:,channel);
img_threshold = img;
img_threshold(img_threshold(:,:)<(channel_threshold/255)) = 0;
lvl = graythresh(img_threshold);
img_otsu = img_threshold > lvl;
%     I_morph = imerode(I_threshold,strel('square',2));
img_stats = regionprops(img_otsu,'Centroid','Area');
area_thresh  = 5;
area_filter = [img_stats.Area]<area_thresh;
img_stats(area_filter) = [];
centroids = round(cat(1, img_stats.Centroid));
numb_of_dots = length(img_stats);
[n,m] = size(img(:,:,1));
[X,Y] = meshgrid(1:m,1:n);

sparse_map = zeros(numb_of_dots,3);

for i = 1:numb_of_dots
% outlier detection
    if (centroids(i,2)-patch_size/2-1)>0 && ...
       (centroids(i,2)+patch_size/2)<n && ...
       (centroids(i,1)-patch_size/2-1)>0 && ...
       (centroids(i,1)+patch_size/2)<m

        img_patch = img_ff(centroids(i,2)-patch_size/2+1:centroids(i,2)+patch_size/2,...
                            centroids(i,1)-patch_size/2+1:centroids(i,1)+patch_size/2,channel);
        img_patch = img_patch.*255;
        
        sparse_map(i,1:2) = centroids(i,1:2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%continuous depth label%%%%%%%%%%%%%%%%%%%%%%%%%%
%         scores = convnet_r.predict(I_patch);
%         depth = sum(scores'.*str2double(convnet_r.Layers(13,1).ClassNames));
%         sparse_map(i,3) = depth;
%%%%%%%%%%%%%%%%%%%%%%%%%%%discrete depth label%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        depth = classify(convnet_r,img_patch);
        sparse_map(i,3) = str2double(cellstr(depth));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        heat_map(centroids(i,2),centroids(i,1))=depth;
    end
end
sparse_map_r2 = sparse_map;

%% b1
channel = 3;
folder_b = [root_dir object '\b\' ];
files = dir([folder_b '*.png']);
d1 = im2double(imread([folder_b files(3).name]));
d2 = im2double(imread([folder_b files(4).name]));
d3 = im2double(imread([folder_b files(5).name]));
f1 = im2double(imread([folder_b files(6).name]));
f2 = im2double(imread([folder_b files(7).name]));
f3 = im2double(imread([folder_b files(8).name]));
d = (d1+d2+d3)./3;
f = (f1+f2+f3)./3;

r = im2double(imread([folder_b files(1).name]));
img_ff = (r-d)./(f-d);
img = img_ff(:,:,channel);
img_threshold = img;
img_threshold(img_threshold(:,:)<(channel_threshold/255)) = 0;
lvl = graythresh(img_threshold);
img_otsu = img_threshold > lvl;
%     I_morph = imerode(I_threshold,strel('square',2));
img_stats = regionprops(img_otsu,'Centroid','Area');
area_thresh  = 5;
area_filter = [img_stats.Area]<area_thresh;
img_stats(area_filter) = [];
centroids = round(cat(1, img_stats.Centroid));
numb_of_dots = length(img_stats);
[n,m] = size(img(:,:,1));
[X,Y] = meshgrid(1:m,1:n);

sparse_map = zeros(numb_of_dots,3);

for i = 1:numb_of_dots
% outlier detection
    if (centroids(i,2)-patch_size/2-1)>0 && ...
       (centroids(i,2)+patch_size/2)<n && ...
       (centroids(i,1)-patch_size/2-1)>0 && ...
       (centroids(i,1)+patch_size/2)<m

        img_patch = img_ff(centroids(i,2)-patch_size/2+1:centroids(i,2)+patch_size/2,...
                            centroids(i,1)-patch_size/2+1:centroids(i,1)+patch_size/2,channel);
        img_patch = img_patch.*255;
        
        sparse_map(i,1:2) = centroids(i,1:2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%continuous depth label%%%%%%%%%%%%%%%%%%%%%%%%%%
%         scores = convnet_r.predict(I_patch);
%         depth = sum(scores'.*str2double(convnet_r.Layers(13,1).ClassNames));
%         sparse_map(i,3) = depth;
%%%%%%%%%%%%%%%%%%%%%%%%%%%discrete depth label%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        depth = classify(convnet_b,img_patch);
        sparse_map(i,3) = str2double(cellstr(depth));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        heat_map(centroids(i,2),centroids(i,1))=depth;
    end
end
sparse_map_b1 = sparse_map;
%% r2
r = im2double(imread([folder_b files(2).name]));
img_ff = (r-d)./(f-d);
img = img_ff(:,:,channel);
img_threshold = img;
img_threshold(img_threshold(:,:)<(channel_threshold/255)) = 0;
lvl = graythresh(img_threshold);
img_otsu = img_threshold > lvl;
%     I_morph = imerode(I_threshold,strel('square',2));
img_stats = regionprops(img_otsu,'Centroid','Area');
area_thresh  = 5;
area_filter = [img_stats.Area]<area_thresh;
img_stats(area_filter) = [];
centroids = round(cat(1, img_stats.Centroid));
numb_of_dots = length(img_stats);
[n,m] = size(img(:,:,1));
[X,Y] = meshgrid(1:m,1:n);

sparse_map = zeros(numb_of_dots,3);

for i = 1:numb_of_dots
% outlier detection
    if (centroids(i,2)-patch_size/2-1)>0 && ...
       (centroids(i,2)+patch_size/2)<n && ...
       (centroids(i,1)-patch_size/2-1)>0 && ...
       (centroids(i,1)+patch_size/2)<m

        img_patch = img_ff(centroids(i,2)-patch_size/2+1:centroids(i,2)+patch_size/2,...
                            centroids(i,1)-patch_size/2+1:centroids(i,1)+patch_size/2,channel);
        img_patch = img_patch.*255;
        
        sparse_map(i,1:2) = centroids(i,1:2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%continuous depth label%%%%%%%%%%%%%%%%%%%%%%%%%%
%         scores = convnet_r.predict(I_patch);
%         depth = sum(scores'.*str2double(convnet_r.Layers(13,1).ClassNames));
%         sparse_map(i,3) = depth;
%%%%%%%%%%%%%%%%%%%%%%%%%%%discrete depth label%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        depth = classify(convnet_b,img_patch);
        sparse_map(i,3) = str2double(cellstr(depth));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        heat_map(centroids(i,2),centroids(i,1))=depth;
    end
end
sparse_map_b2 = sparse_map;
%%
% sparse_map_seq1(sparse_map_seq1(:,3)>=440,:)=[];
% sparse_map_seq2(sparse_map_seq2(:,3)>=440,:)=[];

% sparse_map_median = medianFilter(sparse_map_seq2,5);
% sparse_map_median = medianFilter([sparse_map_seq1; sparse_map_seq2],5);
% sparse_map_median_r1 = medianFilter(sparse_map_r1,5);
% sparse_map_median_r2 = medianFilter(sparse_map_r2,5);
% sparse_map_median_b1 = medianFilter(sparse_map_b1,5);
% sparse_map_median_b2 = medianFilter(sparse_map_b2,5);

sparse_map_median_rb = medianFilter([sparse_map_r1;sparse_map_r2;sparse_map_b1;sparse_map_b2],20);
% sparse_map_median_rb(sparse_map_median_rb(:,3)>=440,:)=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%manual modification%%%%%%%%%%%%%%%%%%%%%%%%%%
% sparse_map_median_rb(sparse_map_median_rb(:,3)>=48,:)=[];
% copy = sparse_map_median_rb;
% 
% sparse_map_median_rb = copy;
% sparse_map_median_rb = sparse_map_median_rb(sparse_map_median_rb(:,2)>=1150,:);
% sparse_map_median_rb(:,2)= (1150-(sparse_map_median_rb(:,2)-1150));
% copy = [copy;sparse_map_median_rb];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% plot sparse_map_seq1_seq2
figure;
hold on
% plot3(sparse_map_median_rb(:,1),sparse_map_median_rb(:,2),sparse_map_median_rb(:,3),'r.','markersize', 10)
plot3(sparse_map_median_rb(:,3),sparse_map_median_rb(:,1),max(sparse_map_median_rb(:,2))-sparse_map_median_rb(:,2),'r.','markersize', 10)
title('sparse map')
legend('Estimated depth(median filter)')
% xlabel('Depth(mm)');ylabel('x (pixel)');zlabel('y (pixel)')
zlabel('Depth(mm)');xlabel('x (pixel)');ylabel('y (pixel)')
grid on

%% surface fit, no overlay
sparse_surf = sparse_map_median_rb;
[xq,yq] = meshgrid(min(sparse_surf(:,1)):max(sparse_surf(:,1)),...
                      min(sparse_surf(:,2)):max(sparse_surf(:,2)));

f = 10;
zq = griddata(sparse_surf(:,1),sparse_surf(:,2),sparse_surf(:,3),...
              xq(1:f:end,1:f:end),yq(1:f:end,1:f:end));
zq(isnan(zq)) = max(sparse_surf(:,3));
figure;imshow(zq,[])

avg_filter_size = 7;
pad_size = (avg_filter_size+1)/2;
zq = padarray(zq,[pad_size pad_size],'replicate');
zq = conv2(zq,fspecial('average',avg_filter_size),'same');
zq = zq(pad_size+1:end-pad_size,pad_size+1:end-pad_size);

figure;
surf(xq(1:f:end,1:f:end),max(yq(:))-yq(1:f:end,1:f:end),zq);
title('surface fit with griddata')
zlabel('Depth(mm)');xlabel('x (pixel)');xlabel('y (pixel)')


%% surface fit with griddata and overlay with original image
sparse_surf = sparse_map_median_rb;
[xq,yq] = meshgrid(min(sparse_surf(:,1)):max(sparse_surf(:,1)),...
                      min(sparse_surf(:,2)):max(sparse_surf(:,2)));

I_fit = imread(['C:\Users\avery\Desktop\DfD\' screen_cap '\recon\' folder_name '\w1.jpg']);
I_fit = rgb2gray(I_fit);
I_fit = I_fit(min(sparse_surf(:,2)):max(sparse_surf(:,2)),...
              min(sparse_surf(:,1)):max(sparse_surf(:,1)));
f = 10;
zq = griddata(sparse_surf(:,1),sparse_surf(:,2),sparse_surf(:,3),...
              xq(1:f:end,1:f:end),yq(1:f:end,1:f:end));
zq(isnan(zq)) = max(sparse_surf(:,3));

avg_filter_size = 7;
pad_size = (avg_filter_size+1)/2;
zq = padarray(zq,[pad_size pad_size],'replicate');
zq = conv2(zq,fspecial('average',avg_filter_size),'same');
zq = zq(pad_size+1:end-pad_size,pad_size+1:end-pad_size);

I_fit = imresize(I_fit,size(zq));

% figure;
% surf(xq(1:f:end,1:f:end),yq(1:f:end,1:f:end),zq,I_fit);
% title('surface fit with griddata and overlay with original image')
% zlabel('Depth(mm)');xlabel('x (pixel)');ylabel('y (pixel)')
% colormap gray

figure;
surf(xq(1:f:end,1:f:end).*(152.4/1075),yq(1:f:end,1:f:end).*(152.4/1075),zq,I_fit);
title('surface fit with griddata and overlay with original image')
zlabel('Depth(mm)');xlabel('x (pixel)');ylabel('y (pixel)')
colormap gray
axis equal
hold on
% figure
[sp_x sp_y sp_z] = sphere(30);
rad = 152.4/2;
sp_x = sp_x.*rad;
sp_y = sp_y.*rad;
sp_z = sp_z.*rad;

surf(sp_x+246,sp_y+156,sp_z+470)