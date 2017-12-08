clc
close all force
clear

%% general parameters
start_depth = 36;
spacing = 1;
numb_of_label = 10;
patch_size = 20;
% channel_threshold = 100;

for p = 1:5
    if p== 1
        pattern = '1x1';
        channel_threshold = 0;
    elseif p == 2
        pattern = '3x3';
        channel_threshold = 170;
    elseif p == 3
        pattern = '3x3cross';
        channel_threshold = 170;
    elseif p == 4
        pattern = 'triangle';
        channel_threshold = 170;
    else
        pattern = 'x';
        channel_threshold = 170;
    end
        
    for h = 1:2
        if h ==1
            root_dir = ['F:\DfD\ScreenCap\20170816ScreenCap\' pattern '\r\'];
            result_dir = ['F:\DfD\ScreenCap\20170816ScreenCap\' pattern '\r\r_train234_ff\'];
            color = 'r';
            channel = 1;
        else
            root_dir = ['F:\DfD\ScreenCap\20170816ScreenCap\' pattern '\b\'];
            result_dir = ['F:\DfD\ScreenCap\20170816ScreenCap\' pattern '\b\b_train234_ff\'];
            color = 'b';
            channel = 3;
        end

        for i = 1:numb_of_label
            label_depth = (start_depth+(i-1)*spacing);
            folder = [root_dir int2str(label_depth) '\'];
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

                        img_patch = img_ff(centroids(j,2)-patch_size/2+1:centroids(j,2)+patch_size/2,...
                                           centroids(j,1)-patch_size/2+1:centroids(j,1)+patch_size/2, channel);
                        img_patch(img_patch<0) = 0;

                        result_name = [color '_' int2str(label_depth) '_' int2str(k) '_' int2str(j)];
                        imwrite(img_patch,[result_path result_name '.png']);
                    end
                end
            end
        end
    end
end

movingFiles_multiPattern_0816
cnnTrain_multiPattern_0816
