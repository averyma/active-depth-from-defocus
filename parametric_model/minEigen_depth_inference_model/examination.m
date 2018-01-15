% clc
% close all force
% clear

%% read calibration images
[file, folder] = uigetfile({'*.jpg','All Image Files'},'Select captured image');
if file == 0, return, end;
files = dir([folder '*.jpg']);

total_files = length(files);

patch_size = 30;
% numb_of_calibration_dots = 5;
% depth_range = 38:47;
% total_depth = length(depth_range);
% depth_vs_EigCov_r = zeros(total_depth,numb_of_calibration_dots+2);
% depth_vs_EigCov_r(:,1) = depth_range;
% depth_vs_EigCov_b = zeros(total_depth,numb_of_calibration_dots+2);
% depth_vs_EigCov_b(:,1) = depth_range;
noise_floor_threshold = 0.15;

filename = file;
% true_depth = str2double(filename(3:4));
I = im2double(imread([folder filename]));

f_I = figure;imshow(I)
while(true)
    %figure;imshow(I(size(I,1)/4:(size(I,1)*3/4),size(I,2)/4:(size(I,2)*3/4),:));
    rect = getrect;
    I_crop = I(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3),:);
    % I = I(rect(2)+size(I,1)/4:rect(2)+rect(4)+size(I,1)/4,rect(1)+size(I,2)/4:rect(1)+rect(3)+size(I,2)/4,:);
    

    % otsu threshold
%     I_split = I_crop(:,:,channel);
    I_split = rgb2gray(I_crop);
    lvl = graythresh(I_split);
    I_threshold = I_split > lvl;
    % morphological operation
    I_morph = imerode(I_threshold,strel('square',2));
    % getting centroids
    I_stats = regionprops(I_morph,'Centroid');
    centroids = round(cat(1, I_stats.Centroid));
    numb_of_dots = length(I_stats);
    %         [n,m] = size(I(:,:,1));
    %         [X,Y] = meshgrid(1:m,1:n);

    if numb_of_dots ~= 1
        'more than one centroid detected!'
        figure;imshow(I_split)
        pause
    end

    for j = 1:1
    % outlier detection
    %             if (centroids(j,2)-15-1)>0 && ...
    %                (centroids(j,2)+15)<n && ...
    %                (centroids(j,1)-15-1)>0 && ...
    %                (centroids(j,1)+15)<m 


        I_patch = I_split(centroids(j,2)-patch_size/2+1:centroids(j,2)+patch_size/2,...
                    centroids(j,1)-patch_size/2+1:centroids(j,1)+patch_size/2);
        f_patch = figure;imshow(I_patch)
        

        % kill noise floor
        I_patch = I_patch - min(I_patch(:));
        I_patch = I_patch./max(I_patch(:));
        I_patch(I_patch<noise_floor_threshold) =0;
        I_patch = I_patch./max(I_patch(:));

        %% finding feature for each patch
        I_patch = round(I_patch *10000);
        [X Y]=meshgrid(1:size(I_patch,1),1:size(I_patch,2));
        sampleConfig = [X(:) Y(:) I_patch(:)];
        sampleSet = zeros(sum(I_patch(:)),2);
        cursor = 1;
        for k = 1:length(sampleConfig)
            if sampleConfig(k,3)~=0
                sampleSet(cursor:cursor+sampleConfig(k,3)-1,:)=repmat(sampleConfig(k,1:2),sampleConfig(k,3),1);
                cursor = cursor + sampleConfig(k,3);
            end
        end

        cov_xy = cov(sampleSet);
        eig_cov = eig(cov_xy)
        r = eig_cov(1)/eig_cov(2)
          

    close(f_patch)
    end
end
depth_vs_EigCov_r(:,end) = mean(depth_vs_EigCov_r(:,2:end-1),2);
depth_vs_EigCov_b(:,end) = mean(depth_vs_EigCov_b(:,2:end-1),2);

