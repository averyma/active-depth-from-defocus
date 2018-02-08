%% this script generates the quantitive test results for CRV 2018 paper
clc
clear
close all

%%
pattern = '1x1'
color = 'b';
channel = 3;
net_path  = ['F:\DfD\ScreenCap\20170816ScreenCap\' pattern '\' color '\' color '_train234_raw\convnet_' color '_train234_raw.mat'];
load(net_path)
patch_size = 20;
channel_threshold = 170;
folder = ['F:\DfD\ScreenCap\20170816ScreenCap\' pattern '\' color '\'];
result_list = [];

for i = 36:45
    img = [folder int2str(i) '\' color '_' int2str(i) '_1.png']; 
    img_r = im2double(imread(img));
    img_threshold = img_r(:,:,channel);
    
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
    [n,m] = size(img_r(:,:,1));
    [X,Y] = meshgrid(1:m,1:n);

    for j = 1:numb_of_dots
    % outlier detection
        if (centroids(j,2)-patch_size/2-1)>0 && ...
           (centroids(j,2)+patch_size/2)<n && ...
           (centroids(j,1)-patch_size/2-1)>0 && ...
           (centroids(j,1)+patch_size/2)<m 

            img_patch = img_r(centroids(j,2)-patch_size/2+1:centroids(j,2)+patch_size/2,...
                               centroids(j,1)-patch_size/2+1:centroids(j,1)+patch_size/2, channel);
            img_patch(img_patch<0) = 0;
            output_depth = str2double(cellstr(classify(convnet,uint8(img_patch.*255))));
            result = [output_depth i];
            result_list = [result_list;result];
        end
    end
    
end

abs_accuracy_b = sum( result_list(:,1) == result_list(:,2) ) / length(result_list);
mar_accuracy_b = sum( abs(result_list(:,1) - result_list(:,2)) < 2) / length(result_list);
mea_b = mean(abs(result_list(:,1) - result_list(:,2)));

pattern = '1x1';
color = 'r';
channel = 1;
net_path  = ['F:\DfD\ScreenCap\20170816ScreenCap\' pattern '\' color '\' color '_train234_raw\convnet_' color '_train234_raw.mat'];
load(net_path)
patch_size = 20;
channel_threshold = 170;
folder = ['F:\DfD\ScreenCap\20170816ScreenCap\' pattern '\' color '\'];
result_list = [];

for i = 36:45
    img = [folder int2str(i) '\' color '_' int2str(i) '_1.png']; 
    img_r = im2double(imread(img));
    img_threshold = img_r(:,:,channel);
    
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
    [n,m] = size(img_r(:,:,1));
    [X,Y] = meshgrid(1:m,1:n);

    for j = 1:numb_of_dots
    % outlier detection
        if (centroids(j,2)-patch_size/2-1)>0 && ...
           (centroids(j,2)+patch_size/2)<n && ...
           (centroids(j,1)-patch_size/2-1)>0 && ...
           (centroids(j,1)+patch_size/2)<m 

            img_patch = img_r(centroids(j,2)-patch_size/2+1:centroids(j,2)+patch_size/2,...
                               centroids(j,1)-patch_size/2+1:centroids(j,1)+patch_size/2, channel);
            img_patch(img_patch<0) = 0;
            output_depth = str2double(cellstr(classify(convnet,uint8(img_patch.*255))));
            result = [output_depth i];
            result_list = [result_list;result];
        end
    end
    
end

abs_accuracy_r = sum( result_list(:,1) == result_list(:,2) ) / length(result_list);
mar_accuracy_r = sum( abs(result_list(:,1) - result_list(:,2)) < 2) / length(result_list);
mea_r = mean(abs(result_list(:,1) - result_list(:,2)));

abs_accuracy = (abs_accuracy_r + abs_accuracy_b) /2
mar_accuracy = (mar_accuracy_r+mar_accuracy_b)/2
mea = (mea_r+mea_b)/2
