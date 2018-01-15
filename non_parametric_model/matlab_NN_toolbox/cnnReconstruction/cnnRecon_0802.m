% close all
clc
clear

%%
network_name = 'train234_raw';
object = 'hand_1';
load(['F:\DfD\ScreenCap\20170728ScreenCap\r\r_' network_name '\convnet_r_' network_name '.mat']);
convnet_r = convnet;
load(['F:\DfD\ScreenCap\20170728ScreenCap\b\b_' network_name '\convnet_b_' network_name '.mat']);
convnet_b = convnet;
root_dir = 'F:\DfD\ScreenCap\20170803ScreenCap\Recon\';
patch_size = 20;
channel_threshold = 170;
rez = [2464 3280];
heat_map = zeros(rez);
sparse_map_rb = [];

%%
for cap = 1:2
    if cap == 1 % red
        channel = 1;
        channel_dir = [root_dir object '\r\' ];
        convnet = convnet_r;
    else % blue
        channel = 3;
        channel_dir = [root_dir object '\b\' ];
        convnet = convnet_b;
    end
    
    files = dir([channel_dir '*.png']);
    d1 = im2double(imread([files(3).folder '\' files(3).name]));
    d2 = im2double(imread([files(4).folder '\' files(4).name]));
    d3 = im2double(imread([files(5).folder '\' files(5).name]));
    f1 = im2double(imread([files(6).folder '\' files(6).name]));
    f2 = im2double(imread([files(7).folder '\' files(7).name]));
    f3 = im2double(imread([files(8).folder '\' files(8).name]));
    d = (d1+d2+d3)./3;
    f = (f1+f2+f3)./3;
    
    for seq = 1:2
        img_r = im2double(imread([files(seq).folder '\' files(seq).name]));
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
        sparse_map_temp = zeros(numb_of_dots,3);
        
        for i = 1:numb_of_dots
            % outlier detection
                if (centroids(i,2)-patch_size/2-1)>0 && ...
                   (centroids(i,2)+patch_size/2)<n && ...
                   (centroids(i,1)-patch_size/2-1)>0 && ...
                   (centroids(i,1)+patch_size/2)<m

                    img_patch = img_r(centroids(i,2)-patch_size/2+1:centroids(i,2)+patch_size/2,...
                                        centroids(i,1)-patch_size/2+1:centroids(i,1)+patch_size/2,channel);
                    img_patch(img_patch<0) = 0;
                    img_patch = img_patch.*255;

                    sparse_map_temp(i,1:2) = centroids(i,1:2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%continuous depth label%%%%%%%%%%%%%%
            %         scores = convnet_r.predict(I_patch);
            %         depth = sum(scores'.*str2double(convnet_r.Layers(13,1).ClassNames));
            %         sparse_map(i,3) = depth;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%discrete depth label%%%%%%%%%%%%%%%%
                    depth = classify(convnet,img_patch);
                    sparse_map_temp(i,3) = str2double(cellstr(depth))/10;    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                end
        end
            sparse_map_rb = [sparse_map_rb;sparse_map_temp];
    end
end

%% select region from figure
temp = sparse_map_rb;
sparse_map_rb = temp;

figure;imshow(img_r);
rect = getrect;
sparse_map_rb(sparse_map_rb(:,1)<=rect(1),:) = [];
sparse_map_rb(sparse_map_rb(:,1)>=(rect(1)+rect(3)),:) = [];
sparse_map_rb(sparse_map_rb(:,2)>=(rect(2)+rect(4)),:) = [];
sparse_map_rb(sparse_map_rb(:,2)<=rect(2),:) = [];

%%
sparse_map_rb_median = medianFilter(sparse_map_rb,20);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% plot sparse_map_seq1_seq2
% figure;
% hold on
% plot3(sparse_map_rb_median(:,1),sparse_map_rb_median(:,2),sparse_map_rb_median(:,3),'r.','markersize', 10)
% % plot3(sparse_map_rb_median(:,3),sparse_map_rb_median(:,1),max(sparse_map_rb_median(:,2))-sparse_map_rb_median(:,2),'r.','markersize', 10)
% title('sparse map')
% legend('Estimated depth(median filter)')
% % xlabel('Depth(mm)');ylabel('x (pixel)');zlabel('y (pixel)')
% zlabel('Depth(mm)');xlabel('x (pixel)');ylabel('y (pixel)')
% grid on

%% surface fit, no overlay
sparse_surf = sparse_map_rb_median;
[xq,yq] = meshgrid(min(sparse_surf(:,1)):max(sparse_surf(:,1)),...
                      min(sparse_surf(:,2)):max(sparse_surf(:,2)));

f = 1;
zq = griddata(sparse_surf(:,1),sparse_surf(:,2),sparse_surf(:,3),...
              xq(1:f:end,1:f:end),yq(1:f:end,1:f:end));
zq(isnan(zq)) = max(sparse_surf(:,3));
%min(zq(:))
%max(zq(:))
zq = (zq-min(zq(:)))./(max(zq(:))-min(zq(:)));
% zq = 1-zq;

% zq = zq./max(zq(:));
min(zq(:))
max(zq(:))
figure;imshow(max(zq(:))-zq)
% imwrite(zq,'hemisphere_1.png');

avg_filter_size = 11;
pad_size = (avg_filter_size+1)/2;
zq = padarray(zq,[pad_size pad_size],'replicate');
zq = conv2(zq,fspecial('average',avg_filter_size),'same');
zq = zq(pad_size+1:end-pad_size,pad_size+1:end-pad_size);

figure;
surf(xq(1:f:end,1:f:end),max(yq(:))-yq(1:f:end,1:f:end),zq);
title('surface fit with griddata')
zlabel('Depth(mm)');xlabel('x (pixel)');xlabel('y (pixel)')


%% surface fit with griddata and overlay with original image
sparse_surf = sparse_map_rb_median;
[xq,yq] = meshgrid(min(sparse_surf(:,1)):max(sparse_surf(:,1)),...
                      min(sparse_surf(:,2)):max(sparse_surf(:,2)));

img_fit = d(min(sparse_surf(:,2)):max(sparse_surf(:,2)),...
              min(sparse_surf(:,1)):max(sparse_surf(:,1)),channel);
img_fit = imresize(img_fit,size(zq));

figure;
surf(xq(1:f:end,1:f:end),yq(1:f:end,1:f:end),zq,img_fit);
title('surface fit with griddata and overlay with original image')
zlabel('Depth(mm)');xlabel('x (pixel)');ylabel('y (pixel)')
colormap gray
hold on
% figure
% [sp_x sp_y sp_z] = sphere(30);
% rad = 152.4/2;
% sp_x = sp_x.*rad;
% sp_y = sp_y.*rad;
% sp_z = sp_z.*rad;
% 
% surf(sp_x+246,sp_y+156,sp_z+470)