% original generateTrainingPattern code for pointgray camera capture
clc
close all force
clear

[file, folder] = uigetfile({'*.png','All Image Files'},'Select captured image');
if file == 0, return, end;

files = dir([folder '*.png']);

resultDir = [folder 'training_sample/'];
if ~exist(resultDir,'dir') % check if result folder exists
    mkdir(resultDir);
end

total_files = length(files);
    
resultDir_red = [resultDir 'red/'];
resultDir_blue = [resultDir 'blue/'];
    
if ~exist(resultDir_red,'dir') % check if result folder exists
    mkdir(resultDir_red);
end
    
if ~exist(resultDir_blue,'dir') % check if result folder exists
    mkdir(resultDir_blue);
end

patch_size = [200 200];
name_red = {};
name_blue = {};
depth_red= [];
depth_blue = [];
blue=1;
red =1;

% file name has to be saved as dist_dist_*****.png, 
% examples of captured plane and corresponding name:
% vertical at 50cm: 20161022_50_50.png
% slanted from 50cm to 60cm(left@50cm, right@60cm): 50_60_***.png
for i = 1: total_files
    filename = files(i).name
    % here we extract depth of the captured image from its file name
    % change to regexp for more complicated file name later
    true_depth = [str2double(filename(1:2)) str2double(filename(4:5))];
%     true_depth = str2double(filename(1:2));
    I = im2double(imread([folder filename]));
    % crop top and bottom row
    I(1,:,:) = [];
    I(end,:,:) = [];
    
%% red:
    if red
        % otsu threshold
        I_red = I(:,:,1);
%         I_red = rgb2gray(I);
        lvl = graythresh(I_red);
        I_threshold = I_red > lvl;
        % morphological operation
        I_morph = imerode(I_threshold,strel('square',8));
        % getting centroids
        I_stats = regionprops(I_morph,'Centroid');
        centroids = round(cat(1, I_stats.Centroid));
        numb_of_dots = length(I_stats);

    %%%%%%%%%%%%%%%find shortest distance pair within a point set%%%%%%%%%%%%%%
        [d] = findShortestDistance(centroids);

        [n,m] = size(I(:,:,1));
        [X,Y] = meshgrid(1:m,1:n);
    %         figure
    %         hold on

    %%%%%%%%%%%% uncomment this section to verify centroids/radius %%%%%%%%%%%%
    %         figure;
    %         % imshow(imadjust(I));
    %         imshow(I);
    %         hold on
    %         for n = 1:numb_of_dots
    %             plot(centroids(n,1),centroids(n,2),'r.','markersize',20);
    %             ang=0:0.001:2*pi; 
    %             xp=d/2*cos(ang);
    %             yp=d/2*sin(ang);
    %             plot(centroids(n,1)+xp,centroids(n,2)+yp,'r','LineWidth',4);    
    %         end
    %         close all
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        for j = 1:numb_of_dots
    %             centroids(j,:)
    %             plot(centroids(j,1),centroids(j,2),'r.');
    %             axis([0 m 0 n])
            % outlier detection
            if (centroids(j,2)-round(patch_size(2)/2)-1)>0 && ...
               (centroids(j,2)+round(patch_size(2)/2))<n && ...
               (centroids(j,1)-round(patch_size(1)/2)-1)>0 && ...
               (centroids(j,1)+round(patch_size(2)/2))<m 

                dist_from_centroid =  sqrt((X-centroids(j,1)).^2 + (Y-centroids(j,2)).^2);
                dist_from_centroid(dist_from_centroid>d/2)=0;
                dist_from_centroid(dist_from_centroid~=0)=1;
                dist_from_centroid(centroids(j,2),centroids(j,1))=1;

                I_mask = dist_from_centroid;
                I_patch = I_mask .* I_red;
                I_patch = I_patch(centroids(j,2)-round(patch_size(1)/2)+1:centroids(j,2)+round(patch_size(1)/2),...
                                  centroids(j,1)-round(patch_size(1)/2)+1:centroids(j,1)+round(patch_size(1)/2));  

    %                 figure;imshow(I_patch,[])
    % close all
                curr_depth = true_depth(1)+(true_depth(1)-true_depth(2))*(centroids(j,1)/m);
                depth_red = [depth_red; curr_depth];             
                saved_name = ['train_red_' num2str(length(depth_red)) '.png'];
                name_red(length(name_red)+1,1) = {saved_name};
                imwrite(I_patch,[resultDir_red saved_name]);
            end
        end
    end
%% blue:
    if blue
        % otsu threshold
        I_blue = I(:,:,3);
        lvl = graythresh(I_blue);
        I_threshold = I_blue > lvl;
        % morphological operation
        I_morph = imerode(I_threshold,strel('square',8));
        % getting centroids
        I_stats = regionprops(I_morph,'Centroid');
        centroids = round(cat(1, I_stats.Centroid));
        numb_of_dots = length(I_stats);

    %%%%%%%%%%%%%%%find shortest distance pair within a point set%%%%%%%%%%%%%%
        [d] = findShortestDistance(centroids);

        [n,m] = size(I(:,:,3));
        [X,Y] = meshgrid(1:m,1:n);
    %         figure
    %         hold on

    %%%%%%%%%%%% uncomment this section to verify centroids/radius %%%%%%%%%%%%
    %         figure;
    %         % imshow(imadjust(I));
    %         imshow(I);
    %         hold on
    %         for n = 1:numb_of_dots
    %             plot(centroids(n,1),centroids(n,2),'r.','markersize',20);
    %             ang=0:0.001:2*pi; 
    %             xp=d/2*cos(ang);
    %             yp=d/2*sin(ang);
    %             plot(centroids(n,1)+xp,centroids(n,2)+yp,'r','LineWidth',4);    
    %         end
    %         close all
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        for j = 1:numb_of_dots
    %             centroids(j,:)
    %             plot(centroids(j,1),centroids(j,2),'r.');
    %             axis([0 m 0 n])
            % outlier detection
            if (centroids(j,2)-round(patch_size(2)/2)-1)>0 && ...
               (centroids(j,2)+round(patch_size(2)/2))<n && ...
               (centroids(j,1)-round(patch_size(1)/2)-1)>0 && ...
               (centroids(j,1)+round(patch_size(2)/2))<m 

                dist_from_centroid =  sqrt((X-centroids(j,1)).^2 + (Y-centroids(j,2)).^2);
                dist_from_centroid(dist_from_centroid>d/2)=0;
                dist_from_centroid(dist_from_centroid~=0)=1;
                dist_from_centroid(centroids(j,2),centroids(j,1))=1;

                I_mask = dist_from_centroid;
                I_patch = I_mask .* I_blue;
                I_patch = I_patch(centroids(j,2)-round(patch_size(1)/2)+1:centroids(j,2)+round(patch_size(1)/2),...
                                  centroids(j,1)-round(patch_size(1)/2)+1:centroids(j,1)+round(patch_size(1)/2));  

    %                 figure;imshow(I_patch,[])
                curr_depth = true_depth(1)+(true_depth(1)-true_depth(2))*(centroids(j,1)/m);
                depth_blue = [depth_blue; curr_depth];             
                saved_name = ['train_blue_' num2str(length(depth_blue)) '.png'];
                name_blue(length(name_blue)+1,1) = {saved_name};
                imwrite(I_patch,[resultDir_blue saved_name]);
            end
        end
    end
end

if red
    train_red = struct('name',name_red,'depth',num2cell(depth_red));
    save([resultDir_red 'train_red.mat'],'train_red')
end

if blue
    train_blue = struct('name',name_blue,'depth',num2cell(depth_blue));
    save([resultDir_blue 'train_blue.mat'],'train_blue')
end


