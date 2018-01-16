close all
clc
clear
load('C:\Users\avery\Desktop\DfD\20170510ScreenCap\r\train234_test1\convnet_r.mat');
convnet_r = net1r;
load('C:\Users\avery\Desktop\DfD\20170510ScreenCap\b\train234_test1\convnet_b.mat');
convnet_b = net1b;
%%
fit_image = '';
screen_cap = '20170510ScreenCap';
folder_name = 'dome';
pic_name_r_seq1 = [fit_image 'r1'];
pic_name_r_seq2 = [fit_image 'r2'];
pic_name_b_seq1 = [fit_image 'b1'];
pic_name_b_seq2 = [fit_image 'b2'];
channel_threshold_r = 40;
channel_threshold_b = 40;

%% r1
filename = ['C:\Users\avery\Desktop\DfD\' screen_cap '\recon\' folder_name '\' pic_name_r_seq1 '.jpg'];

patch_size = 20;
I = im2double(imread(filename));
I_red = I(:,:,1);
I_red(I_red(:)<(channel_threshold_r/255)) = 0;

lvl = graythresh(I_red);
I_threshold = I_red > lvl;
I_morph = imerode(I_threshold,strel('square',2));
I_cc = bwconncomp(I_morph);
I_props = regionprops(I_cc,'Area');
area_thresh  = 5;
area_filter = [I_props.Area]<area_thresh;
I_cc.PixelIdxList(area_filter) = [];
I_aa = zeros(size(I));
I_aa(cell2mat(I_cc.PixelIdxList.')) = 1;

% getting centroids
I_aa = bwconncomp(I_aa);
I_stats = regionprops(I_aa,'Centroid');
centroids = round(cat(1, I_stats.Centroid));
numb_of_centroids = length(I_stats);
[n,m] = size(I(:,:,1));
[X,Y] = meshgrid(1:m,1:n);
sparse_map = zeros(numb_of_centroids,3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = im2double(imread(filename));
I_red = I(:,:,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:numb_of_centroids
    

    % outlier detection
%     if (centroids(i,2)-15-1)>0 && ...
%        (centroids(i,2)+15)<n && ...
%        (centroids(i,1)-15-1)>0 && ...
%        (centroids(i,1)+15)<m 

        I_patch = uint8(I_red(centroids(i,2)-patch_size/2+1:centroids(i,2)+patch_size/2,...
                              centroids(i,1)-patch_size/2+1:centroids(i,1)+patch_size/2).*255);    
%         I_patch = rgb2gray(I_patch);
%         I_patch = uint8(I_patch.*255);
        
%         figure;imshow(I_patch)
                      
        sparse_map(i,1:2) = centroids(i,1:2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%continuous depth label%%%%%%%%%%%%%%%%%%%%%%%%%%
%         scores = convnet_r.predict(I_patch);
%         depth = sum(scores'.*str2double(convnet_r.Layers(13,1).ClassNames));
%         sparse_map(i,3) = depth;
%%%%%%%%%%%%%%%%%%%%%%%%%%%discrete depth label%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        depth = classify(convnet_r,I_patch);
        sparse_map(i,3) = str2double(cellstr(depth));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%     end
end
sparse_map_r1 = sparse_map;

%% r2
filename = ['C:\Users\avery\Desktop\DfD\' screen_cap '\recon\' folder_name '\' pic_name_r_seq2 '.jpg'];
I = im2double(imread(filename));
I_red = I(:,:,1);
I_red(I_red(:)<(channel_threshold_r/255)) = 0;

lvl = graythresh(I_red);
I_threshold = I_red > lvl;
I_morph = imerode(I_threshold,strel('square',2));
I_cc = bwconncomp(I_morph);
I_props = regionprops(I_cc,'Area');
area_thresh  = 5;
area_filter = [I_props.Area]<area_thresh;
I_cc.PixelIdxList(area_filter) = [];
I_aa = zeros(size(I));
I_aa(cell2mat(I_cc.PixelIdxList.')) = 1;

% getting centroids
I_aa = bwconncomp(I_aa);
I_stats = regionprops(I_aa,'Centroid');
centroids = round(cat(1, I_stats.Centroid));
numb_of_centroids = length(I_stats);
[n,m] = size(I(:,:,1));
[X,Y] = meshgrid(1:m,1:n);
sparse_map = zeros(numb_of_centroids,3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = im2double(imread(filename));
I_red = I(:,:,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:numb_of_centroids
    

    % outlier detection
%     if (centroids(i,2)-15-1)>0 && ...
%        (centroids(i,2)+15)<n && ...
%        (centroids(i,1)-15-1)>0 && ...
%        (centroids(i,1)+15)<m 

        I_patch = uint8(I_red(centroids(i,2)-patch_size/2+1:centroids(i,2)+patch_size/2,...
                              centroids(i,1)-patch_size/2+1:centroids(i,1)+patch_size/2).*255);    
%         I_patch = rgb2gray(I_patch);
%         I_patch = uint8(I_patch.*255);
        
%         figure;imshow(I_patch)
                      
        sparse_map(i,1:2) = centroids(i,1:2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%continuous depth label%%%%%%%%%%%%%%%%%%%%%%%%%%
%         scores = convnet_r.predict(I_patch);
%         depth = sum(scores'.*str2double(convnet_r.Layers(13,1).ClassNames));    
%         sparse_map(i,3) = depth;
%%%%%%%%%%%%%%%%%%%%%%%%%%%discrete depth label%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        depth = classify(convnet_r,I_patch);
        sparse_map(i,3) = str2double(cellstr(depth));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%     end
end
sparse_map_r2 = sparse_map;

%% b1
filename = ['C:\Users\avery\Desktop\DfD\' screen_cap '\recon\' folder_name '\' pic_name_b_seq1 '.jpg'];

patch_size = 20;
I = im2double(imread(filename));
I_red = I(:,:,3);
I_red(I_red(:)<(channel_threshold_b/255)) = 0;

lvl = graythresh(I_red);
I_threshold = I_red > lvl;
% figure;imshow(I_threshold)
% morphological operation
I_morph = imerode(I_threshold,strel('square',2));
% figure;imshow(I_morph)
% area threshold 
I_cc = bwconncomp(I_morph);
I_props = regionprops(I_cc,'Area');
area_thresh  = 5;
area_filter = [I_props.Area]<area_thresh;
I_cc.PixelIdxList(area_filter) = [];
I_aa = zeros(size(I));
I_aa(cell2mat(I_cc.PixelIdxList.')) = 1;

% getting centroids
I_aa = bwconncomp(I_aa);
I_stats = regionprops(I_aa,'Centroid');
centroids = round(cat(1, I_stats.Centroid));
numb_of_centroids = length(I_stats);
[n,m] = size(I(:,:,1));
[X,Y] = meshgrid(1:m,1:n);
sparse_map = zeros(numb_of_centroids,3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = im2double(imread(filename));
I_red = I(:,:,3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:numb_of_centroids
    

    % outlier detection
%     if (centroids(i,2)-15-1)>0 && ...
%        (centroids(i,2)+15)<n && ...
%        (centroids(i,1)-15-1)>0 && ...
%        (centroids(i,1)+15)<m 

        I_patch = uint8(I_red(centroids(i,2)-patch_size/2+1:centroids(i,2)+patch_size/2,...
                              centroids(i,1)-patch_size/2+1:centroids(i,1)+patch_size/2).*255);    
%         I_patch = rgb2gray(I_patch);
%         I_patch = uint8(I_patch.*255);
        
%         figure;imshow(I_patch)
                      
        sparse_map(i,1:2) = centroids(i,1:2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%continuous depth label%%%%%%%%%%%%%%%%%%%%%%%%%%
%         scores = convnet_b.predict(I_patch);
%         depth = sum(scores'.*str2double(convnet_b.Layers(13,1).ClassNames));
%         sparse_map(i,3) = depth;
%%%%%%%%%%%%%%%%%%%%%%%%%%%discrete depth label%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        depth = classify(convnet_b,I_patch);
        sparse_map(i,3) = str2double(cellstr(depth));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%     end
end
sparse_map_b1 = sparse_map;

%% b2
filename = ['C:\Users\avery\Desktop\DfD\' screen_cap '\recon\' folder_name '\' pic_name_b_seq2 '.jpg'];

patch_size = 20;
I = im2double(imread(filename));
I_red = I(:,:,3);
I_red(I_red(:)<(channel_threshold_b/255)) = 0;

lvl = graythresh(I_red);
I_threshold = I_red > lvl;
% figure;imshow(I_threshold)
% morphological operation
I_morph = imerode(I_threshold,strel('square',2));
% figure;imshow(I_morph)
% area threshold 
I_cc = bwconncomp(I_morph);
I_props = regionprops(I_cc,'Area');
area_thresh  = 5;
area_filter = [I_props.Area]<area_thresh;
I_cc.PixelIdxList(area_filter) = [];
I_aa = zeros(size(I));
I_aa(cell2mat(I_cc.PixelIdxList.')) = 1;

% getting centroids
I_aa = bwconncomp(I_aa);
I_stats = regionprops(I_aa,'Centroid');
centroids = round(cat(1, I_stats.Centroid));
numb_of_centroids = length(I_stats);
[n,m] = size(I(:,:,1));
[X,Y] = meshgrid(1:m,1:n);
sparse_map = zeros(numb_of_centroids,3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = im2double(imread(filename));
I_red = I(:,:,3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:numb_of_centroids
    

    % outlier detection
%     if (centroids(i,2)-15-1)>0 && ...
%        (centroids(i,2)+15)<n && ...
%        (centroids(i,1)-15-1)>0 && ...
%        (centroids(i,1)+15)<m 

        I_patch = uint8(I_red(centroids(i,2)-patch_size/2+1:centroids(i,2)+patch_size/2,...
                              centroids(i,1)-patch_size/2+1:centroids(i,1)+patch_size/2).*255);    
%         I_patch = rgb2gray(I_patch);
%         I_patch = uint8(I_patch.*255);
        
%         figure;imshow(I_patch)
                      
        sparse_map(i,1:2) = centroids(i,1:2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%continuous depth label%%%%%%%%%%%%%%%%%%%%%%%%%%
%         scores = convnet_b.predict(I_patch);
%         depth = sum(scores'.*str2double(convnet_b.Layers(13,1).ClassNames));  
%         sparse_map(i,3) = depth;
%%%%%%%%%%%%%%%%%%%%%%%%%%%discrete depth label%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        depth = classify(convnet_b,I_patch);
        sparse_map(i,3) = str2double(cellstr(depth));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     end
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

%% plot sparse_map_seq1_seq2
figure;
hold on
plot3(sparse_map_median_rb(:,3),sparse_map_median_rb(:,1),max(sparse_map_median_rb(:,2))-sparse_map_median_rb(:,2),'r.','markersize', 10)
title('sparse map')
legend('Estimated depth(median filter)')
xlabel('Depth(mm)');ylabel('x (pixel)');zlabel('y (pixel)')
grid on

%% surface fit, no overlay
sparse_surf = sparse_map_median_rb;
[xq,yq] = meshgrid(min(sparse_surf(:,1)):max(sparse_surf(:,1)),...
                      min(sparse_surf(:,2)):max(sparse_surf(:,2)));

f = 10;
zq = griddata(sparse_surf(:,1),sparse_surf(:,2),sparse_surf(:,3),...
              xq(1:f:end,1:f:end),yq(1:f:end,1:f:end));
zq(isnan(zq)) = max(sparse_surf(:,3));

avg_filter_size = 7;
pad_size = (avg_filter_size+1)/2;
zq = padarray(zq,[pad_size pad_size],'replicate');
zq = conv2(zq,fspecial('average',avg_filter_size),'same');
zq = zq(pad_size+1:end-pad_size,pad_size+1:end-pad_size);

figure;
surf(xq(1:f:end,1:f:end),max(yq(:))-yq(1:f:end,1:f:end),zq);
title('surface fit with griddata')
xlabel('Depth(mm)');ylabel('x (pixel)');zlabel('y (pixel)')


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