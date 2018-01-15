% edited: change file format to jpg since iphone capture jpg images. 

clc
close all force
clear

[file, folder] = uigetfile({'*.jpg','All Image Files'},'Select captured image');
if file == 0, return, end;

files = dir([folder '*.jpg']);

resultDir = [folder 'training_sample/'];
if ~exist(resultDir,'dir') % check if result folder exists
    mkdir(resultDir);
end

total_files = length(files);
   
resultDir_red = [resultDir];
% resultDir_red = [resultDir 'red/'];
% resultDir_blue = [resultDir 'blue/'];
    
if ~exist(resultDir_red,'dir') % check if result folder exists
    mkdir(resultDir_red);
end
    
% if ~exist(resultDir_blue,'dir') % check if result folder exists
%     mkdir(resultDir_blue);
% end

patch_size = [50 50];
name_red = {};
% name_blue = {};
depth_red= [];
% depth_blue = [];
red  = 1;
% blue = 0;

% file name has to be saved as dist_*****.png, 
% examples of captured plane and corresponding name:
% at 50cm: 50_***.png
for i = 1: total_files
    filename = files(i).name;
    i/total_files*100
    % here we extract depth of the captured image from its file name
    % change to regexp for more complicated file name later
    true_depth = str2double(filename(1:2));
    I = im2double(imread([folder filename]));
    % cropping iphone captures
    top_left = [1080 1640]; % x value needs to be varied for different depth: decrease from 1240
    % 25,26:1500 
    % 27: 1430
    % 28: 1400
    % 29: 1340
    % 30: 1320
    % 31: 1300
    
    I = I(top_left(1):top_left(1)+70,...
          top_left(2):top_left(2)+70,:);
%     figure;imshow(I)
%% red:
    if red
        % otsu threshold
%         I_red = I(:,:,1);
        I_red = rgb2gray(I);
        lvl = graythresh(I_red);
        I_threshold = I_red > lvl;
        % morphological operation
        I_morph = imerode(I_threshold,strel('square',2));
        % getting centroids
        I_stats = regionprops(I_morph,'Centroid');
        centroids = round(cat(1, I_stats.Centroid));
        numb_of_dots = length(I_stats);
        [n,m] = size(I(:,:,1));
        [X,Y] = meshgrid(1:m,1:n);
        
        if numb_of_dots ~= 1
            'more than one centroid detected!'
            figure;imshow(I_red)
            pause
        end
    
        for j = 1:1
            % outlier detection
            if (centroids(j,2)-15-1)>0 && ...
               (centroids(j,2)+15)<n && ...
               (centroids(j,1)-15-1)>0 && ...
               (centroids(j,1)+15)<m 

%                 dist_from_centroid = sqrt((X-centroids(j,1)).^2 + (Y-centroids(j,2)).^2);
%                 dist_from_centroid(dist_from_centroid>50)=0;
%                 dist_from_centroid(dist_from_centroid~=0)=1;
%                 dist_from_centroid(centroids(j,2),centroids(j,1))=1;
% 
%                 I_mask = dist_from_centroid;
%                 I_patch = I_mask .* I_red;
                I_patch = I(centroids(j,2)-15+1:centroids(j,2)+15,...
                            centroids(j,1)-15+1:centroids(j,1)+15,:);
                I_patch = rgb2gray(I_patch);
                
                % better represent the I_patch
%                 findMin = I_patch;
%                 findMin(findMin==0) = inf;
%                 findMin = min(findMin(:));
%                 I_patch(I_patch == 0) = findMin;
                
%                 figure;imshow(I_patch,[])
% close all
%                 curr_depth = true_depth(1)+(true_depth(1)-true_depth(2))*(centroids(j,1)/m);
%                 depth_red = [depth_red; true_depth];             
%                 saved_name = ['train_' num2str(true_depth) '_' num2str(i) '.png'];
                saved_name = [num2str(i) '.png'];
%                 name_red(length(name_red)+1,1) = {saved_name};
                imwrite(I_patch,[resultDir_red saved_name]);
                saved_name = [num2str(i) '_rot90.png'];
                imwrite(rot90(I_patch),[resultDir_red saved_name]);
                saved_name = [num2str(i) '_rot180.png'];
                imwrite(rot90(rot90(I_patch)),[resultDir_red saved_name]);
                saved_name = [num2str(i) '_rot270.png'];
                imwrite(rot90(rot90(rot90(I_patch))),[resultDir_red saved_name]);
            end
        end
    end
end

close all