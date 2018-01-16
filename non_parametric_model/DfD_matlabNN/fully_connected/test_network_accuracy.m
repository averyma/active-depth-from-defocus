clc
clear
close all
iptsetpref('ImshowBorder','tight')

net_path  = ['C:\Users\avery\Desktop\DfD\20170501ScreenCap\nothreshold\b\train234_test1\convnet_b.mat'];
load(net_path)

folder = ['C:\Users\avery\Desktop\DfD\20170501ScreenCap\nothreshold\b\train234_test1\test1\'];
test_images = dir([folder '*.jpg']);

numb_of_images = 20;
patch_size = [20 20];

% numb_of_dots = 3217;
numb_of_dots = 3184;

target = zeros(20,numb_of_dots*20);
output = zeros(20,numb_of_dots*20);
result_list = zeros(numb_of_dots*20,2);
mean_depth_error = zeros(1,20);

off_by_5mm = 0;
channel = 3;
channel_threshold = 40;
net1 = net1b;
% net2 = net2b;
% net3 = net3b;
% net4 = net4b;
% net5 = net5b;


'net1'
for i = 1: length(test_images)
    filename = test_images(i).name;
    I = im2double(imread([folder filename]));
    I_red = I(:,:,channel);

    I_red(I_red(:,:)<(channel_threshold/255)) = 0;

    lvl = graythresh(I_red);
    I_threshold = I_red > lvl;
%     I_morph = imerode(I_threshold,strel('square',2));
    I_stats = regionprops(I_threshold,'Centroid','Area');
    area_thresh  = 10;
    area_filter = [I_stats.Area]<area_thresh;
    I_stats(area_filter) = [];
    centroids = round(cat(1, I_stats.Centroid));
    
    if numb_of_dots ~= length(I_stats)
        length(I_stats)
    end
    
    [n,m] = size(I(:,:,1));
    [X,Y] = meshgrid(1:m,1:n);

    for j = 1: numb_of_dots
    %     filename = files(i).name;
        ((i-1)*numb_of_dots+j)/(numb_of_dots*20)*100;
        I_patch = I_red(centroids(j,2)-patch_size/2+1:centroids(j,2)+patch_size/2,...
                        centroids(j,1)-patch_size/2+1:centroids(j,1)+patch_size/2);
        I_patch = uint8(I_patch.*255);


        target_depth = str2double(filename(1:3))/10;
%         scores = net1(reshape(I_patch',[400 1]));
%         output_depth = (find(scores == max(scores))-1)*0.5+38;

        output_depth = str2double(cellstr(classify(net1,I_patch)))/10;

        target_index = target_depth*2-75;
        output_index = output_depth*2-75;

        target(target_index,(i-1)*numb_of_dots+j) = 1;
        output(output_index,(i-1)*numb_of_dots+j) = 1;

        result_list((i-1)*numb_of_dots+j,1:2) = [target_depth output_depth];
        mean_depth_error(target_index) = ...
            mean_depth_error(target_index)+...
                abs(target_depth - output_depth);
    end
end


mean_depth_error = mean_depth_error./numb_of_dots;

% confusionmat(result_list(:,1),result_list(:,2))
mean_depth_error_global = mean(abs(result_list(:,1) - result_list(:,2)))
accuracy = sum(result_list(:,1) == result_list(:,2))/length(result_list)
accuracy_no_less_than_5mm = sum(abs(result_list(:,1) - result_list(:,2))<=0.5)/length(result_list)

%%
'net2'
for i = 1: length(test_images)
    filename = test_images(i).name;
    I = im2double(imread([folder filename]));
    I_red = I(:,:,channel);
    
    I_red(I_red(:,:)<(channel_threshold/255)) = 0;

    lvl = graythresh(I_red);
    I_threshold = I_red > lvl;
%     I_morph = imerode(I_threshold,strel('square',2));
    I_stats = regionprops(I_threshold,'Centroid','Area');
    area_thresh  = 10;
    area_filter = [I_stats.Area]<area_thresh;
    I_stats(area_filter) = [];
    centroids = round(cat(1, I_stats.Centroid));
    
    if numb_of_dots ~= length(I_stats)
        length(I_stats)
    end
    
    [n,m] = size(I(:,:,1));
    [X,Y] = meshgrid(1:m,1:n);

    for j = 1: numb_of_dots
    %     filename = files(i).name;
        ((i-1)*numb_of_dots+j)/(numb_of_dots*20)*100;
        I_patch = I_red(centroids(j,2)-patch_size/2+1:centroids(j,2)+patch_size/2,...
                        centroids(j,1)-patch_size/2+1:centroids(j,1)+patch_size/2);
        I_patch = uint8(I_patch.*255);


        target_depth = str2double(filename(1:3))/10;
%         scores = net2(reshape(I_patch',[400 1]));
%         output_depth = (find(scores == max(scores))-1)*0.5+38;

        output_depth = str2double(cellstr(classify(net2,I_patch)))/10;

        target_index = target_depth*2-75;
        output_index = output_depth*2-75;

        target(target_index,(i-1)*numb_of_dots+j) = 1;
        output(output_index,(i-1)*numb_of_dots+j) = 1;

        result_list((i-1)*numb_of_dots+j,1:2) = [target_depth output_depth];
        mean_depth_error(target_index) = ...
            mean_depth_error(target_index)+...
                abs(target_depth - output_depth);
    end
end


mean_depth_error = mean_depth_error./numb_of_dots;

% confusionmat(result_list(:,1),result_list(:,2))
mean_depth_error_global = mean(abs(result_list(:,1) - result_list(:,2)))
accuracy = sum(result_list(:,1) == result_list(:,2))/length(result_list)
accuracy_no_less_than_5mm = sum(abs(result_list(:,1) - result_list(:,2))<=0.5)/length(result_list)

%%
'net3'
for i = 1: length(test_images)
    filename = test_images(i).name;
    I = im2double(imread([folder filename]));
    I_red = I(:,:,channel);
    
    I_red(I_red(:,:)<(channel_threshold/255)) = 0;

    lvl = graythresh(I_red);
    I_threshold = I_red > lvl;
%     I_morph = imerode(I_threshold,strel('square',2));
    I_stats = regionprops(I_threshold,'Centroid','Area');
    area_thresh  = 10;
    area_filter = [I_stats.Area]<area_thresh;
    I_stats(area_filter) = [];
    centroids = round(cat(1, I_stats.Centroid));
    
    if numb_of_dots ~= length(I_stats)
        length(I_stats)
    end
    
    [n,m] = size(I(:,:,1));
    [X,Y] = meshgrid(1:m,1:n);

    for j = 1: numb_of_dots
    %     filename = files(i).name;
        ((i-1)*numb_of_dots+j)/(numb_of_dots*20)*100;
        I_patch = I_red(centroids(j,2)-patch_size/2+1:centroids(j,2)+patch_size/2,...
                        centroids(j,1)-patch_size/2+1:centroids(j,1)+patch_size/2);
        I_patch = uint8(I_patch.*255);


        target_depth = str2double(filename(1:3))/10;
%         scores = net3(reshape(I_patch',[400 1]));
%         output_depth = (find(scores == max(scores))-1)*0.5+38;

        output_depth = str2double(cellstr(classify(net3,I_patch)))/10;

        target_index = target_depth*2-75;
        output_index = output_depth*2-75;

        target(target_index,(i-1)*numb_of_dots+j) = 1;
        output(output_index,(i-1)*numb_of_dots+j) = 1;

        result_list((i-1)*numb_of_dots+j,1:2) = [target_depth output_depth];
        mean_depth_error(target_index) = ...
            mean_depth_error(target_index)+...
                abs(target_depth - output_depth);
    end
end


mean_depth_error = mean_depth_error./numb_of_dots;

% confusionmat(result_list(:,1),result_list(:,2))
mean_depth_error_global = mean(abs(result_list(:,1) - result_list(:,2)))
accuracy = sum(result_list(:,1) == result_list(:,2))/length(result_list)
accuracy_no_less_than_5mm = sum(abs(result_list(:,1) - result_list(:,2))<=0.5)/length(result_list)

%%
'net4'
for i = 1: length(test_images)
    filename = test_images(i).name;
    I = im2double(imread([folder filename]));
    I_red = I(:,:,channel);
    
    I_red(I_red(:,:)<(channel_threshold/255)) = 0;

    lvl = graythresh(I_red);
    I_threshold = I_red > lvl;
%     I_morph = imerode(I_threshold,strel('square',2));
    I_stats = regionprops(I_threshold,'Centroid','Area');
    area_thresh  = 10;
    area_filter = [I_stats.Area]<area_thresh;
    I_stats(area_filter) = [];
    centroids = round(cat(1, I_stats.Centroid));
    
    if numb_of_dots ~= length(I_stats)
        length(I_stats)
    end
    
    [n,m] = size(I(:,:,1));
    [X,Y] = meshgrid(1:m,1:n);

    for j = 1: numb_of_dots
    %     filename = files(i).name;
        ((i-1)*numb_of_dots+j)/(numb_of_dots*20)*100;
        I_patch = I_red(centroids(j,2)-patch_size/2+1:centroids(j,2)+patch_size/2,...
                        centroids(j,1)-patch_size/2+1:centroids(j,1)+patch_size/2);
        I_patch = uint8(I_patch.*255);


        target_depth = str2double(filename(1:3))/10;
%         scores = net4(reshape(I_patch',[400 1]));
%         output_depth = (find(scores == max(scores))-1)*0.5+38;

        output_depth = str2double(cellstr(classify(net4,I_patch)))/10;

        target_index = target_depth*2-75;
        output_index = output_depth*2-75;

        target(target_index,(i-1)*numb_of_dots+j) = 1;
        output(output_index,(i-1)*numb_of_dots+j) = 1;

        result_list((i-1)*numb_of_dots+j,1:2) = [target_depth output_depth];
        mean_depth_error(target_index) = ...
            mean_depth_error(target_index)+...
                abs(target_depth - output_depth);
    end
end


mean_depth_error = mean_depth_error./numb_of_dots;

% confusionmat(result_list(:,1),result_list(:,2))
mean_depth_error_global = mean(abs(result_list(:,1) - result_list(:,2)))
accuracy = sum(result_list(:,1) == result_list(:,2))/length(result_list)
accuracy_no_less_than_5mm = sum(abs(result_list(:,1) - result_list(:,2))<=0.5)/length(result_list)

%%
'net5'
for i = 1: length(test_images)
    filename = test_images(i).name;
    I = im2double(imread([folder filename]));
    I_red = I(:,:,channel);
    
    I_red(I_red(:,:)<(channel_threshold/255)) = 0;

    lvl = graythresh(I_red);
    I_threshold = I_red > lvl;
%     I_morph = imerode(I_threshold,strel('square',2));
    I_stats = regionprops(I_threshold,'Centroid','Area');
    area_thresh  = 10;
    area_filter = [I_stats.Area]<area_thresh;
    I_stats(area_filter) = [];
    centroids = round(cat(1, I_stats.Centroid));
    
    if numb_of_dots ~= length(I_stats)
        length(I_stats)
    end
    
    [n,m] = size(I(:,:,1));
    [X,Y] = meshgrid(1:m,1:n);

    for j = 1: numb_of_dots
    %     filename = files(i).name;
        ((i-1)*numb_of_dots+j)/(numb_of_dots*20)*100;
        I_patch = I_red(centroids(j,2)-patch_size/2+1:centroids(j,2)+patch_size/2,...
                        centroids(j,1)-patch_size/2+1:centroids(j,1)+patch_size/2);
        I_patch = uint8(I_patch.*255);


        target_depth = str2double(filename(1:3))/10;
%         scores = net5(reshape(I_patch',[400 1]));
%         output_depth = (find(scores == max(scores))-1)*0.5+38;

        output_depth = str2double(cellstr(classify(net5,I_patch)))/10;

        target_index = target_depth*2-75;
        output_index = output_depth*2-75;

        target(target_index,(i-1)*numb_of_dots+j) = 1;
        output(output_index,(i-1)*numb_of_dots+j) = 1;

        result_list((i-1)*numb_of_dots+j,1:2) = [target_depth output_depth];
        mean_depth_error(target_index) = ...
            mean_depth_error(target_index)+...
                abs(target_depth - output_depth);
    end
end


mean_depth_error = mean_depth_error./numb_of_dots;

% confusionmat(result_list(:,1),result_list(:,2))
mean_depth_error_global = mean(abs(result_list(:,1) - result_list(:,2)))
accuracy = sum(result_list(:,1) == result_list(:,2))/length(result_list)
accuracy_no_less_than_5mm = sum(abs(result_list(:,1) - result_list(:,2))<=0.5)/length(result_list)