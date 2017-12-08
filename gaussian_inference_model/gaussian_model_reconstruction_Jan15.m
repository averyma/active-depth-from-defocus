%% gaussian_model_reconstruction_Jan15
recon_folder = '/Users/ama/Desktop/DfD/ScreenCap/gaussian_approach/20170114ScreenCap/test/';
% recon_folder = '/Users/ama/Desktop/DfD/ScreenCap/gaussian_approach/20170213ScreenCap/test/';
I_recon = im2double(imread([recon_folder 'staircase4b.jpg']));

%% red 
channel = 1;
I_split = I_recon(:,:,channel);

% I_split(I_split(:)<35/255) = 0;

lvl = graythresh(I_split);
I_threshold = I_split > lvl;
% morphological operation
I_morph = imerode(I_threshold,strel('square',3));

% getting centroids
I_stats = regionprops(I_morph,'Centroid','Area');
patch_size = 30;
noise_floor_threshold = 0.15;
area_thresh  = 20;
area_filter = [I_stats.Area]<area_thresh;
I_stats(area_filter) = [];
centroids = round(cat(1, I_stats.Centroid));
numb_of_dots = length(I_stats);

sparse_map_r = zeros(numb_of_dots,3); 
[n,m] = size(I_recon(:,:,1));

for j = 1:numb_of_dots
    j/numb_of_dots*100
% outlier detection
%             if (centroids(j,2)-15-1)>0 && ...
%                (centroids(j,2)+15)<n && ...
%                (centroids(j,1)-15-1)>0 && ...
%                (centroids(j,1)+15)<m 


    I_patch = I_split(centroids(j,2)-patch_size/2+1:centroids(j,2)+patch_size/2,...
                centroids(j,1)-patch_size/2+1:centroids(j,1)+patch_size/2);
%     figure;imshow(I_patch)

    % kill noise floor
    I_patch = I_patch - min(I_patch(:));
    I_patch = I_patch./max(I_patch(:));
    I_patch(I_patch<noise_floor_threshold) =0;
    I_patch = I_patch./max(I_patch(:));
    
    
    
    sparse_map_r(j,1:2) = centroids(j,1:2);
    sparse_map_r(j,3) = curve_r(maxEigCov(I_patch));
%             end
end

%% Blue 
channel = 3;
I_split = I_recon(:,:,channel);
% I_split(I_split(:)<50/255) = 0;

lvl = graythresh(I_split);
I_threshold = I_split > lvl;
% morphological operation
I_morph = imerode(I_threshold,strel('square',3));

% getting centroids
I_stats = regionprops(I_morph,'Centroid','Area');
area_thresh  = 10;
area_filter = [I_stats.Area]<area_thresh;
I_stats(area_filter) = [];
centroids = round(cat(1, I_stats.Centroid));
numb_of_dots = length(I_stats);

sparse_map_b = zeros(numb_of_dots,3); 

for j = 1:numb_of_dots
    j/numb_of_dots*100
% outlier detection
%             if (centroids(j,2)-15-1)>0 && ...
%                (centroids(j,2)+15)<n && ...
%                (centroids(j,1)-15-1)>0 && ...
%                (centroids(j,1)+15)<m 


    I_patch = I_split(centroids(j,2)-patch_size/2+1:centroids(j,2)+patch_size/2,...
                centroids(j,1)-patch_size/2+1:centroids(j,1)+patch_size/2);
%     figure;imshow(I_patch)

    % kill noise floor
    I_patch = I_patch - min(I_patch(:));
    I_patch = I_patch./max(I_patch(:));
    I_patch(I_patch<noise_floor_threshold) =0;
    I_patch = I_patch./max(I_patch(:));
    
    sparse_map_b(j,1:2) = centroids(j,1:2);
    sparse_map_b(j,3) = curve_b(maxEigCov(I_patch));
end

figure;
hold on
plot3(sparse_map_r(:,1),sparse_map_r(:,2),sparse_map_r(:,3),'r.','markersize', 15)
plot3(sparse_map_b(:,1),sparse_map_b(:,2),sparse_map_b(:,3),'b.','markersize', 15)
