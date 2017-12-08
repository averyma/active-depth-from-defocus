% close all
clc
clear

%%
ffORraw = 'raw';
network_name = ['train234_' ffORraw];
object = 'hand2_36';

pattern = '1x1';
load(['F:\DfD\ScreenCap\20170816ScreenCap\' pattern '\r\r_' network_name '\convnet_r_' network_name '.mat']);
convnet_r = convnet;
load(['F:\DfD\ScreenCap\20170816ScreenCap\' pattern '\b\b_' network_name '\convnet_b_' network_name '.mat']);
convnet_b = convnet;
root_dir = ['F:\DfD\ScreenCap\20170816ScreenCap\recon\'];
patch_size = 20;
channel_threshold = 0;
wavelength_1 = 2;
wavelength_2 = 2;
sparse_map_rb_1x1 = [];
sparse_map_rb_3x3 = [];
sparse_map_rb_3x3cross = [];
sparse_map_rb_triangle = [];
sparse_map_rb_x = [];

%%
for cap = wavelength_1 : wavelength_2
    switch cap
        case 1 %red
        	channel = 1;
            channel_dir = [root_dir object '\' pattern '\r\'];
            convnet = convnet_r;
        case 2 %blue
            channel = 3;
            channel_dir = [root_dir object '\' pattern '\b\'];
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
        
        if cap == 1 && seq ==1 % r_1
            centroids_r1 = centroids;
        elseif cap == 1 && seq ==2 % r_2
            centroids_r2 = centroids;
        elseif cap == 2 && seq ==1 % b_1
            centroids_b1 = centroids;
        else %b_2
            centroids_b2 = centroids;
        end
        
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
                    
                if strcmp(ffORraw,'raw')
                    img_patch = img_r(centroids(i,2)-patch_size/2+1:centroids(i,2)+patch_size/2,...
                    centroids(i,1)-patch_size/2+1:centroids(i,1)+patch_size/2,channel);
                else
                    img_patch = img_ff(centroids(i,2)-patch_size/2+1:centroids(i,2)+patch_size/2,...
                    centroids(i,1)-patch_size/2+1:centroids(i,1)+patch_size/2,channel);
                end

                    img_patch(img_patch<0) = 0;
                    img_patch = img_patch.*255;

                    sparse_map_temp(i,1:2) = centroids(i,1:2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%continuous depth label%%%%%%%%%%%%%%
            %         scores = convnet_r.predict(I_patch);
            %         depth = sum(scores'.*str2double(convnet_r.Layers(13,1).ClassNames));
            %         sparse_map(i,3) = depth;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%discrete depth label%%%%%%%%%%%%%%%%
                    depth = classify(convnet,img_patch);
                    sparse_map_temp(i,3) = str2double(cellstr(depth));    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                end
        end
            sparse_map_rb_1x1 = [sparse_map_rb_1x1;sparse_map_temp];
    end
end

%%
pattern = '3x3';
load(['F:\DfD\ScreenCap\20170816ScreenCap\' pattern '\r\r_' network_name '\convnet_r_' network_name '.mat']);
convnet_r = convnet;
load(['F:\DfD\ScreenCap\20170816ScreenCap\' pattern '\b\b_' network_name '\convnet_b_' network_name '.mat']);
convnet_b = convnet;
for cap = wavelength_1 : wavelength_2
    switch cap
        case 1 %red
        	channel = 1;
            channel_dir = [root_dir object '\' pattern '\r\'];
            convnet = convnet_r;
        case 2 %blue
            channel = 3;
            channel_dir = [root_dir object '\' pattern '\b\'];
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
        
        if cap == 1 && seq ==1 % r_1
            centroids = centroids_r1; 
        elseif cap == 1 && seq ==2 % r_2
            centroids = centroids_r2;
        elseif cap == 2 && seq ==1 % b_1
            centroids = centroids_b1;
        else %b_2
            centroids = centroids_b2;
        end
        
        numb_of_dots = length(centroids);
        [n,m] = size(img_r(:,:,1));
        [X,Y] = meshgrid(1:m,1:n);
        sparse_map_temp = zeros(numb_of_dots,3);
        
        for i = 1:numb_of_dots
            % outlier detection
                if (centroids(i,2)-patch_size/2-1)>0 && ...
                   (centroids(i,2)+patch_size/2)<n && ...
                   (centroids(i,1)-patch_size/2-1)>0 && ...
                   (centroids(i,1)+patch_size/2)<m

                if strcmp(ffORraw,'raw')
                    img_patch = img_r(centroids(i,2)-patch_size/2+1:centroids(i,2)+patch_size/2,...
                    centroids(i,1)-patch_size/2+1:centroids(i,1)+patch_size/2,channel);
                else
                    img_patch = img_ff(centroids(i,2)-patch_size/2+1:centroids(i,2)+patch_size/2,...
                    centroids(i,1)-patch_size/2+1:centroids(i,1)+patch_size/2,channel);
                end
                    img_patch(img_patch<0) = 0;
                    img_patch = img_patch.*255;

                    sparse_map_temp(i,1:2) = centroids(i,1:2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%continuous depth label%%%%%%%%%%%%%%
            %         scores = convnet_r.predict(I_patch);
            %         depth = sum(scores'.*str2double(convnet_r.Layers(13,1).ClassNames));
            %         sparse_map(i,3) = depth;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%discrete depth label%%%%%%%%%%%%%%%%
                    depth = classify(convnet,img_patch);
                    sparse_map_temp(i,3) = str2double(cellstr(depth));    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                end
        end
            sparse_map_rb_3x3 = [sparse_map_rb_3x3;sparse_map_temp];
    end
end

%%
pattern = '3x3cross';
load(['F:\DfD\ScreenCap\20170816ScreenCap\' pattern '\r\r_' network_name '\convnet_r_' network_name '.mat']);
convnet_r = convnet;
load(['F:\DfD\ScreenCap\20170816ScreenCap\' pattern '\b\b_' network_name '\convnet_b_' network_name '.mat']);
convnet_b = convnet;
for cap = wavelength_1 : wavelength_2
    switch cap
        case 1 %red
        	channel = 1;
            channel_dir = [root_dir object '\' pattern '\r\'];
            convnet = convnet_r;
        case 2 %blue
            channel = 3;
            channel_dir = [root_dir object '\' pattern '\b\'];
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
        
        if cap == 1 && seq ==1 % r_1
            centroids = centroids_r1; 
        elseif cap == 1 && seq ==2 % r_2
            centroids = centroids_r2;
        elseif cap == 2 && seq ==1 % b_1
            centroids = centroids_b1;
        else %b_2
            centroids = centroids_b2;
        end
        
        numb_of_dots = length(centroids);
        [n,m] = size(img_r(:,:,1));
        [X,Y] = meshgrid(1:m,1:n);
        sparse_map_temp = zeros(numb_of_dots,3);
        
        for i = 1:numb_of_dots
            % outlier detection
                if (centroids(i,2)-patch_size/2-1)>0 && ...
                   (centroids(i,2)+patch_size/2)<n && ...
                   (centroids(i,1)-patch_size/2-1)>0 && ...
                   (centroids(i,1)+patch_size/2)<m

                if strcmp(ffORraw,'raw')
                    img_patch = img_r(centroids(i,2)-patch_size/2+1:centroids(i,2)+patch_size/2,...
                    centroids(i,1)-patch_size/2+1:centroids(i,1)+patch_size/2,channel);
                else
                    img_patch = img_ff(centroids(i,2)-patch_size/2+1:centroids(i,2)+patch_size/2,...
                    centroids(i,1)-patch_size/2+1:centroids(i,1)+patch_size/2,channel);
                end
                    img_patch(img_patch<0) = 0;
                    img_patch = img_patch.*255;

                    sparse_map_temp(i,1:2) = centroids(i,1:2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%continuous depth label%%%%%%%%%%%%%%
            %         scores = convnet_r.predict(I_patch);
            %         depth = sum(scores'.*str2double(convnet_r.Layers(13,1).ClassNames));
            %         sparse_map(i,3) = depth;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%discrete depth label%%%%%%%%%%%%%%%%
                    depth = classify(convnet,img_patch);
                    sparse_map_temp(i,3) = str2double(cellstr(depth));    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                end
        end
            sparse_map_rb_3x3cross = [sparse_map_rb_3x3cross;sparse_map_temp];
    end
end

%%
pattern = 'triangle';
load(['F:\DfD\ScreenCap\20170816ScreenCap\' pattern '\r\r_' network_name '\convnet_r_' network_name '.mat']);
convnet_r = convnet;
load(['F:\DfD\ScreenCap\20170816ScreenCap\' pattern '\b\b_' network_name '\convnet_b_' network_name '.mat']);
convnet_b = convnet;
for cap = wavelength_1 : wavelength_2
    switch cap
        case 1 %red
        	channel = 1;
            channel_dir = [root_dir object '\' pattern '\r\'];
            convnet = convnet_r;
        case 2 %blue
            channel = 3;
            channel_dir = [root_dir object '\' pattern '\b\'];
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
        
        if cap == 1 && seq ==1 % r_1
            centroids = centroids_r1; 
        elseif cap == 1 && seq ==2 % r_2
            centroids = centroids_r2;
        elseif cap == 2 && seq ==1 % b_1
            centroids = centroids_b1;
        else %b_2
            centroids = centroids_b2;
        end
        
        numb_of_dots = length(centroids);
        [n,m] = size(img_r(:,:,1));
        [X,Y] = meshgrid(1:m,1:n);
        sparse_map_temp = zeros(numb_of_dots,3);
        
        for i = 1:numb_of_dots
            % outlier detection
                if (centroids(i,2)-patch_size/2-1)>0 && ...
                   (centroids(i,2)+patch_size/2)<n && ...
                   (centroids(i,1)-patch_size/2-1)>0 && ...
                   (centroids(i,1)+patch_size/2)<m

                if strcmp(ffORraw,'raw')
                    img_patch = img_r(centroids(i,2)-patch_size/2+1:centroids(i,2)+patch_size/2,...
                    centroids(i,1)-patch_size/2+1:centroids(i,1)+patch_size/2,channel);
                else
                    img_patch = img_ff(centroids(i,2)-patch_size/2+1:centroids(i,2)+patch_size/2,...
                    centroids(i,1)-patch_size/2+1:centroids(i,1)+patch_size/2,channel);
                end
                    img_patch(img_patch<0) = 0;
                    img_patch = img_patch.*255;

                    sparse_map_temp(i,1:2) = centroids(i,1:2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%continuous depth label%%%%%%%%%%%%%%
            %         scores = convnet_r.predict(I_patch);
            %         depth = sum(scores'.*str2double(convnet_r.Layers(13,1).ClassNames));
            %         sparse_map(i,3) = depth;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%discrete depth label%%%%%%%%%%%%%%%%
                    depth = classify(convnet,img_patch);
                    sparse_map_temp(i,3) = str2double(cellstr(depth));    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                end
        end
            sparse_map_rb_triangle = [sparse_map_rb_triangle;sparse_map_temp];
    end
end

%%
pattern = 'x';
load(['F:\DfD\ScreenCap\20170816ScreenCap\' pattern '\r\r_' network_name '\convnet_r_' network_name '.mat']);
convnet_r = convnet;
load(['F:\DfD\ScreenCap\20170816ScreenCap\' pattern '\b\b_' network_name '\convnet_b_' network_name '.mat']);
convnet_b = convnet;
for cap = wavelength_1 : wavelength_2
    switch cap
        case 1 %red
        	channel = 1;
            channel_dir = [root_dir object '\' pattern '\r\'];
            convnet = convnet_r;
        case 2 %blue
            channel = 3;
            channel_dir = [root_dir object '\' pattern '\b\'];
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
        
        if cap == 1 && seq ==1 % r_1
            centroids = centroids_r1; 
        elseif cap == 1 && seq ==2 % r_2
            centroids = centroids_r2;
        elseif cap == 2 && seq ==1 % b_1
            centroids = centroids_b1;
        else %b_2
            centroids = centroids_b2;
        end
        
        numb_of_dots = length(centroids);
        [n,m] = size(img_r(:,:,1));
        [X,Y] = meshgrid(1:m,1:n);
        sparse_map_temp = zeros(numb_of_dots,3);
        
        for i = 1:numb_of_dots
            % outlier detection
                if (centroids(i,2)-patch_size/2-1)>0 && ...
                   (centroids(i,2)+patch_size/2)<n && ...
                   (centroids(i,1)-patch_size/2-1)>0 && ...
                   (centroids(i,1)+patch_size/2)<m

                if strcmp(ffORraw,'raw')
                    img_patch = img_r(centroids(i,2)-patch_size/2+1:centroids(i,2)+patch_size/2,...
                    centroids(i,1)-patch_size/2+1:centroids(i,1)+patch_size/2,channel);
                else
                    img_patch = img_ff(centroids(i,2)-patch_size/2+1:centroids(i,2)+patch_size/2,...
                    centroids(i,1)-patch_size/2+1:centroids(i,1)+patch_size/2,channel);
                end
                    img_patch(img_patch<0) = 0;
                    img_patch = img_patch.*255;

                    sparse_map_temp(i,1:2) = centroids(i,1:2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%continuous depth label%%%%%%%%%%%%%%
            %         scores = convnet_r.predict(I_patch);
            %         depth = sum(scores'.*str2double(convnet_r.Layers(13,1).ClassNames));
            %         sparse_map(i,3) = depth;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%discrete depth label%%%%%%%%%%%%%%%%
                    depth = classify(convnet,img_patch);
                    sparse_map_temp(i,3) = str2double(cellstr(depth));    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                end
        end
            sparse_map_rb_x = [sparse_map_rb_x;sparse_map_temp];
    end
end

%% select region from figure
figure;imshow(img_r);
[BW, poly_x, poly_y] = roipoly;

in = inpolygon(sparse_map_rb_1x1(:,1),sparse_map_rb_1x1(:,2),...
                poly_x,poly_y);
            
sparse_map_rb_1x1 = sparse_map_rb_1x1(in,:);
sparse_map_rb_3x3 = sparse_map_rb_3x3(in,:);
sparse_map_rb_3x3cross = sparse_map_rb_3x3cross(in,:);
sparse_map_rb_triangle = sparse_map_rb_triangle(in,:);
sparse_map_rb_x = sparse_map_rb_x(in,:);

%% median filtering
sparse_map_rb_1x1_median = medianFilter(sparse_map_rb_1x1,20);
sparse_map_rb_3x3_median = medianFilter(sparse_map_rb_3x3,20);
sparse_map_rb_3x3cross_median = medianFilter(sparse_map_rb_3x3cross,20);
sparse_map_rb_triangle_median = medianFilter(sparse_map_rb_triangle,20);
sparse_map_rb_x_median = medianFilter(sparse_map_rb_x,20);

%% surface fit, no overlay
f = 1;
sparse_surf = sparse_map_rb_1x1_median;
[xq,yq] = meshgrid(min(sparse_surf(:,1)):max(sparse_surf(:,1)),...
                      min(sparse_surf(:,2)):max(sparse_surf(:,2)));
zq = griddata(sparse_surf(:,1),sparse_surf(:,2),sparse_surf(:,3),...
              xq(1:f:end,1:f:end),yq(1:f:end,1:f:end));
zq(isnan(zq)) = max(sparse_surf(:,3));
zq = (zq-min(zq(:)))./(max(zq(:))-min(zq(:)));
heatmap_1x1 = max(zq)-zq;
%
sparse_surf = sparse_map_rb_3x3_median;
[xq,yq] = meshgrid(min(sparse_surf(:,1)):max(sparse_surf(:,1)),...
                      min(sparse_surf(:,2)):max(sparse_surf(:,2)));
zq = griddata(sparse_surf(:,1),sparse_surf(:,2),sparse_surf(:,3),...
              xq(1:f:end,1:f:end),yq(1:f:end,1:f:end));
zq(isnan(zq)) = max(sparse_surf(:,3));
zq = (zq-min(zq(:)))./(max(zq(:))-min(zq(:)));
heatmap_3x3 = max(zq)-zq;
%
sparse_surf = sparse_map_rb_3x3cross_median;
[xq,yq] = meshgrid(min(sparse_surf(:,1)):max(sparse_surf(:,1)),...
                      min(sparse_surf(:,2)):max(sparse_surf(:,2)));
zq = griddata(sparse_surf(:,1),sparse_surf(:,2),sparse_surf(:,3),...
              xq(1:f:end,1:f:end),yq(1:f:end,1:f:end));
zq(isnan(zq)) = max(sparse_surf(:,3));
zq = (zq-min(zq(:)))./(max(zq(:))-min(zq(:)));
heatmap_3x3cross = max(zq)-zq;
%
sparse_surf = sparse_map_rb_triangle_median;
[xq,yq] = meshgrid(min(sparse_surf(:,1)):max(sparse_surf(:,1)),...
                      min(sparse_surf(:,2)):max(sparse_surf(:,2)));
zq = griddata(sparse_surf(:,1),sparse_surf(:,2),sparse_surf(:,3),...
              xq(1:f:end,1:f:end),yq(1:f:end,1:f:end));
zq(isnan(zq)) = max(sparse_surf(:,3));
zq = (zq-min(zq(:)))./(max(zq(:))-min(zq(:)));
heatmap_triangle = max(zq)-zq;
%
sparse_surf = sparse_map_rb_x_median;
[xq,yq] = meshgrid(min(sparse_surf(:,1)):max(sparse_surf(:,1)),...
                      min(sparse_surf(:,2)):max(sparse_surf(:,2)));
zq = griddata(sparse_surf(:,1),sparse_surf(:,2),sparse_surf(:,3),...
              xq(1:f:end,1:f:end),yq(1:f:end,1:f:end));
zq(isnan(zq)) = max(sparse_surf(:,3));
zq = (zq-min(zq(:)))./(max(zq(:))-min(zq(:)));
heatmap_x = max(zq)-zq;

%%
figure;suptitle(ffORraw);
subplot(1,5,1);imshow(heatmap_1x1);title('1x1')
subplot(1,5,2);imshow(heatmap_3x3);title('3x3')
subplot(1,5,3);imshow(heatmap_3x3cross);title('+')
subplot(1,5,4);imshow(heatmap_triangle);title('triangle')
subplot(1,5,5);imshow(heatmap_x);title('x')

imwrite(heatmap_1x1,['F:\DfD\CVIS2017\figure\wavelength_comparison\' object '_1x1_' ffORraw '.png' ]);
imwrite(heatmap_3x3,['F:\DfD\CVIS2017\figure\wavelength_comparison\' object '_3x3_' ffORraw '.png' ]);
imwrite(heatmap_3x3cross,['F:\DfD\CVIS2017\figure\wavelength_comparison\' object '_3x3cross_' ffORraw '.png' ]);
imwrite(heatmap_triangle,['F:\DfD\CVIS2017\figure\wavelength_comparison\' object '_triangle_' ffORraw '.png' ]);
imwrite(heatmap_x,['F:\DfD\CVIS2017\figure\wavelength_comparison\' object '_x_' ffORraw '.png' ]);
