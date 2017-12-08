% select folder with all calibration capture : 

clc
close all force
clear

%% read calibration images
[file, folder] = uigetfile({'*.jpg','All Image Files'},'Select captured image');
if file == 0, return, end;
files = dir([folder '*.jpg']);

total_files = length(files);

patch_size = 30;
numb_of_calibration_dots = 5;
depth_range = 38:47;
total_depth = length(depth_range);
depth_vs_EigCov_r = zeros(total_depth,numb_of_calibration_dots+2);
depth_vs_EigCov_r(:,1) = depth_range;
depth_vs_EigCov_b = zeros(total_depth,numb_of_calibration_dots+2);
depth_vs_EigCov_b(:,1) = depth_range;
noise_floor_threshold = 0.15;


for i = 1: total_files
    filename = files(i).name;
    true_depth = str2double(filename(3:4));
    I = im2double(imread([folder filename]));
    
    figure;imshow(I(size(I,1)/4:(size(I,1)*3/4),size(I,2)/4:(size(I,2)*3/4),:));
    rect = getrect;
    I = I(rect(2)+size(I,1)/4:rect(2)+rect(4)+size(I,1)/4,rect(1)+size(I,2)/4:rect(1)+rect(3)+size(I,2)/4,:);
    close all
    
    color = filename(1);
    if color == 'r'
        % red
        channel = 1;
        I_split = I(:,:,channel);
        I_split(I_split(:)<35/255) =0;
    else
        % blue
        channel = 3;
        I_split = I(:,:,channel);
        I_split(I_split(:)<35/255) =0;
    end
    % otsu threshold
    
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

    if numb_of_dots ~= numb_of_calibration_dots
        'more than one centroid detected!'
        figure;imshow(I_split)
        pause
    end

    for j = 1:5
    % outlier detection
%             if (centroids(j,2)-15-1)>0 && ...
%                (centroids(j,2)+15)<n && ...
%                (centroids(j,1)-15-1)>0 && ...
%                (centroids(j,1)+15)<m 


        I_patch = I_split(centroids(j,2)-patch_size/2+1:centroids(j,2)+patch_size/2,...
                    centroids(j,1)-patch_size/2+1:centroids(j,1)+patch_size/2);
        
%         figure;imshow(I(centroids(j,2)-patch_size/2+1:centroids(j,2)+patch_size/2,...
%                     centroids(j,1)-patch_size/2+1:centroids(j,1)+patch_size/2,:));
                 
                
        % kill noise floor
%         I_patch = I_patch - min(I_patch(:));
%         I_patch = I_patch./max(I_patch(:));
%         I_patch(I_patch<noise_floor_threshold) =0;
%         I_patch = I_patch./max(I_patch(:));
        
        if color == 'r'
            depth_vs_EigCov_r(depth_vs_EigCov_r(:,1)==true_depth,j+1) = maxEigCov(I_patch);
        else
            depth_vs_EigCov_b(depth_vs_EigCov_b(:,1)==true_depth,j+1) = maxEigCov(I_patch);
        end
        
    end
end
close all

depth_vs_EigCov_r(:,end) = mean(depth_vs_EigCov_r(:,2:end-1),2);
depth_vs_EigCov_b(:,end) = mean(depth_vs_EigCov_b(:,2:end-1),2);

%% curve fitting
load /Users/ama/Desktop/DfD/ScreenCap/gaussian_approach/20170114ScreenCap/calibration_curve.mat
curve_r = fit(depth_vs_EigCov_r(:,end),depth_vs_EigCov_r(:,1),'poly3');
curve_b = fit(depth_vs_EigCov_b(:,end),depth_vs_EigCov_b(:,1),'poly3');

% plot curve
figure;
plot(curve_r,'r')
hold on;
plot(curve_b,'b')
plot(depth_vs_EigCov_r(:,end),depth_vs_EigCov_r(:,1),'r.','MarkerSize',20)
plot(depth_vs_EigCov_b(:,end),depth_vs_EigCov_b(:,1),'b.','MarkerSize',20)
xlabel('Minimum Eigenvalue of Covariance'); ylabel('Depth (cm)');
title('Minimum Eigenvalue of Covariance vs. Depth')
legend('Curve Fit Result(Red)','Curve Fit Result(Blue)',...
       'Measurement(Red)','Measurement(Blue)');
grid on

