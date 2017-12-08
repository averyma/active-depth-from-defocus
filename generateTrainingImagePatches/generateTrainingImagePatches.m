clc
close all force
clear

%% general parameters
start_depth = 41.5;
spacing = 0.5;
numb_of_label = 18;
patch_size = 20;
channel_threshold = 170;

for h = 1:2
    if h ==1
        root_dir = 'F:\DfD\ScreenCap\20170811ScreenCap\r\';
        result_dir = 'F:\DfD\ScreenCap\20170811ScreenCap\r\r_train234_raw_415to500\';
        color = 'r';
        channel = 1;
    else
        root_dir = 'F:\DfD\ScreenCap\20170811ScreenCap\b\';
        result_dir = 'F:\DfD\ScreenCap\20170811ScreenCap\b\b_train234_raw_415to500\';
        color = 'b';
        channel = 3;
    end
    
    for i = 1:numb_of_label
        label_depth = (start_depth+(i-1)*spacing)*10;
        folder = [root_dir color '_' int2str(label_depth) '\'];
        files = dir([folder '*.png']);
        d1 = im2double(imread([folder files(5).name]));
        d2 = im2double(imread([folder files(6).name]));
        d3 = im2double(imread([folder files(7).name]));
        f1 = im2double(imread([folder files(8).name]));
        f2 = im2double(imread([folder files(9).name]));
        f3 = im2double(imread([folder files(10).name]));
        d = (d1+d2+d3)./3;
        f = (f1+f2+f3)./3;

        for k = 2:4
            result_path = [result_dir int2str(label_depth) '\' int2str(k) '\'];
            mkdir(result_path)

            img_r = im2double(imread([folder files(k).name]));
            img_ff = (img_r-d)./(f-d);
            img_threshold = img_ff(:,:,channel);
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
                    
                    result_name = [color '_' int2str(label_depth) '_' int2str(k) '_' int2str(j)];
                    imwrite(img_patch,[result_path result_name '.png']);
                end
            end
        end
    end
end