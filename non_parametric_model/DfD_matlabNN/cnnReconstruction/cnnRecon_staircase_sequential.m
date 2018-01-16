close all
load('C:\Users\avery\Desktop\DfD\20170403ScreenCap\070\train234_test1\convnet.mat');
%%
pic_name_seq1 = '2_seq1';
pic_name_seq2 = '2_seq2';
filename = ['C:\Users\avery\Desktop\DfD\20170403ScreenCap\recon\' pic_name_seq1 '.jpg'];

patch_size = 20;
I = im2double(imread(filename));
I_red = I(:,:,1);
channel_threshold = 20;
I_red(I_red(:)<(channel_threshold/255)) = 0;

lvl = graythresh(I_red);
I_threshold = I_red > lvl;
% figure;imshow(I_threshold)
% morphological operation
I_morph = imerode(I_threshold,strel('square',2));
% figure;imshow(I_morph)
% area threshold 
I_cc = bwconncomp(I_morph);
I_props = regionprops(I_cc,'Area');
area_thresh  = 5;
area_filter = [I_props.Area]<area_thresh;
I_cc.PixelIdxList(area_filter) = [];
I_aa = zeros(size(I));
I_aa(cell2mat(I_cc.PixelIdxList.')) = 1;

% getting centroids
I_aa = bwconncomp(I_aa);
I_stats = regionprops(I_aa,'Centroid');
centroids = round(cat(1, I_stats.Centroid));
numb_of_centroids = length(I_stats);
[n,m] = size(I(:,:,1));
[X,Y] = meshgrid(1:m,1:n);
sparse_map = zeros(numb_of_centroids,3);

for i = 1:numb_of_centroids
    

    % outlier detection
%     if (centroids(i,2)-15-1)>0 && ...
%        (centroids(i,2)+15)<n && ...
%        (centroids(i,1)-15-1)>0 && ...
%        (centroids(i,1)+15)<m 

        I_patch = uint8(I_red(centroids(i,2)-patch_size/2+1:centroids(i,2)+patch_size/2,...
                              centroids(i,1)-patch_size/2+1:centroids(i,1)+patch_size/2).*255);    
%         I_patch = rgb2gray(I_patch);
%         I_patch = uint8(I_patch.*255);
        
%         figure;imshow(I_patch)
                      
        sparse_map(i,1:2) = centroids(i,1:2);
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%continuous depth label%%%%%%%%%%%%%%%%%%%%%%%%%%
%         scores = convnet.predict(I_patch);
%         depth = sum(scores'.*str2double(convnet.Layers(12,1).ClassNames));
%         sparse_map(i,3) = depth;
%%%%%%%%%%%%%%%%%%%%%%%%%%%discrete depth label%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        depth = classify(convnet,I_patch);
        sparse_map(i,3) = str2double(cellstr(depth));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     end
end
sparse_map_seq1 = sparse_map;

%%
filename = ['C:\Users\avery\Desktop\DfD\20170403ScreenCap\recon\' pic_name_seq2 '.jpg'];

patch_size = 20;
I = im2double(imread(filename));
I_red = I(:,:,1);
channel_threshold = 20;
I_red(I_red(:)<(channel_threshold/255)) = 0;

lvl = graythresh(I_red);
I_threshold = I_red > lvl;
% figure;imshow(I_threshold)
% morphological operation
I_morph = imerode(I_threshold,strel('square',2));
% figure;imshow(I_morph)
% area threshold 
I_cc = bwconncomp(I_morph);
I_props = regionprops(I_cc,'Area');
area_thresh  = 5;
area_filter = [I_props.Area]<area_thresh;
I_cc.PixelIdxList(area_filter) = [];
I_aa = zeros(size(I));
I_aa(cell2mat(I_cc.PixelIdxList.')) = 1;

% getting centroids
I_aa = bwconncomp(I_aa);
I_stats = regionprops(I_aa,'Centroid');
centroids = round(cat(1, I_stats.Centroid));
numb_of_centroids = length(I_stats);
[n,m] = size(I(:,:,1));
[X,Y] = meshgrid(1:m,1:n);
sparse_map = zeros(numb_of_centroids,3);

for i = 1:numb_of_centroids
    

    % outlier detection
%     if (centroids(i,2)-15-1)>0 && ...
%        (centroids(i,2)+15)<n && ...
%        (centroids(i,1)-1    
%         figure;imshow(I_patch)5-1)>0 && ...
%        (centroids(i,1)+15)<m 

        I_patch = uint8(I_red(centroids(i,2)-patch_size/2+1:centroids(i,2)+patch_size/2,...
                              centroids(i,1)-patch_size/2+1:centroids(i,1)+patch_size/2).*255);    
%         I_patch = rgb2gray(I_patch);
%         I_patch = uint8(I_patch.*255);
    
                      
        sparse_map(i,1:2) = centroids(i,1:2);
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%continuous depth label%%%%%%%%%%%%%%%%%%%%%%%%%%
%         scores = convnet.predict(I_patch);
%         depth = sum(scores'.*str2double(convnet.Layers(12,1).ClassNames));
%         sparse_map(i,3) = depth;
%%%%%%%%%%%%%%%%%%%%%%%%%%%discrete depth label%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        depth = classify(convnet,I_patch);
        sparse_map(i,3) = str2double(cellstr(depth));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     end
end
sparse_map_seq2 = sparse_map;

% sparse_map_seq1(sparse_map_seq1(:,3)>=440,:)=[];
% sparse_map_seq2(sparse_map_seq2(:,3)>=440,:)=[];

% sparse_map_median = medianFilter(sparse_map_seq2,5);
% sparse_map_median = medianFilter([sparse_map_seq1; sparse_map_seq2],5);
sparse_map_median_seq1 = medianFilter(sparse_map_seq1,5);
sparse_map_median_seq2 = medianFilter(sparse_map_seq2,5);
sparse_map_median_seq1_seq2 = medianFilter([sparse_map_seq1; sparse_map_seq2],5);
%% plot sparse_map_seq1/ no median filter
figure;
hold on
plot3(sparse_map_seq1(:,3),sparse_map_seq1(:,1),max(sparse_map_seq1(:,2))-sparse_map_seq1(:,2),'r.','markersize', 10)
plot3(sparse_map_seq2(:,3),sparse_map_seq2(:,1),max(sparse_map_seq2(:,2))-sparse_map_seq2(:,2),'b.','markersize', 10)
title('sparse map')
legend('Estimated depth(median filter)')
xlabel('Depth(mm)');ylabel('x (pixel)');zlabel('y (pixel)')
grid on

%% plot sparse_map_seq1

figure;
hold on
plot3(sparse_map_median_seq1(:,3),sparse_map_median_seq1(:,1),max(sparse_map_median_seq1(:,2))-sparse_map_median_seq1(:,2),'r.','markersize', 10)
title('sparse map')
legend('Estimated depth(median filter)')
xlabel('Depth(mm)');ylabel('x (pixel)');zlabel('y (pixel)')
grid on

%% plot sparse_map_seq2
figure;
hold on
plot3(sparse_map_median_seq2(:,3),sparse_map_median_seq2(:,1),max(sparse_map_median_seq2(:,2))-sparse_map_median_seq2(:,2),'r.','markersize', 10)
title('sparse map')
legend('Estimated depth(median filter)')
xlabel('Depth(mm)');ylabel('x (pixel)');zlabel('y (pixel)')
grid on

%% plot sparse_map_seq1_seq2
figure;
hold on
plot3(sparse_map_median_seq1_seq2(:,3),sparse_map_median_seq1_seq2(:,1),max(sparse_map_median_seq1_seq2(:,2))-sparse_map_median_seq1_seq2(:,2),'r.','markersize', 10)
title('sparse map')
legend('Estimated depth(median filter)')
xlabel('Depth(mm)');ylabel('x (pixel)');zlabel('y (pixel)')
grid on

%%
sparse_surf = sparse_map_median_seq1;
[xq,yq] = meshgrid(min(sparse_surf(:,1)):max(sparse_surf(:,1)),...
                      min(sparse_surf(:,2)):max(sparse_surf(:,2)));

f = 10;
zq = griddata(sparse_surf(:,1),sparse_surf(:,2),sparse_surf(:,3),...
              xq(1:f:end,1:f:end),yq(1:f:end,1:f:end));
zq(isnan(zq)) = max(sparse_surf(:,3));

avg_filter_size = 3;
pad_size = (avg_filter_size+1)/2;
zq = padarray(zq,[pad_size pad_size],'replicate');
zq = conv2(zq,fspecial('average',avg_filter_size),'same');
zq = zq(pad_size+1:end-pad_size,pad_size+1:end-pad_size);

figure;
surf(zq,xq(1:f:end,1:f:end),max(yq(:))-yq(1:f:end,1:f:end));
title('surface fit with griddata')
xlabel('Depth(mm)');ylabel('x (pixel)');zlabel('y (pixel)')
%%
sparse_surf = sparse_map_median_seq2;
[xq,yq] = meshgrid(min(sparse_surf(:,1)):max(sparse_surf(:,1)),...
                      min(sparse_surf(:,2)):max(sparse_surf(:,2)));

f = 10;
zq = griddata(sparse_surf(:,1),sparse_surf(:,2),sparse_surf(:,3),...
              xq(1:f:end,1:f:end),yq(1:f:end,1:f:end));
zq(isnan(zq)) = max(sparse_surf(:,3));

avg_filter_size = 3;
pad_size = (avg_filter_size+1)/2;
zq = padarray(zq,[pad_size pad_size],'replicate');
zq = conv2(zq,fspecial('average',avg_filter_size),'same');
zq = zq(pad_size+1:end-pad_size,pad_size+1:end-pad_size);

figure;
surf(zq,xq(1:f:end,1:f:end),max(yq(:))-yq(1:f:end,1:f:end));
title('surface fit with griddata')
xlabel('Depth(mm)');ylabel('x (pixel)');zlabel('y (pixel)')
%%
sparse_surf = sparse_map_median_seq1_seq2;
[xq,yq] = meshgrid(min(sparse_surf(:,1)):max(sparse_surf(:,1)),...
                      min(sparse_surf(:,2)):max(sparse_surf(:,2)));

f = 10;
zq = griddata(sparse_surf(:,1),sparse_surf(:,2),sparse_surf(:,3),...
              xq(1:f:end,1:f:end),yq(1:f:end,1:f:end));
zq(isnan(zq)) = max(sparse_surf(:,3));

avg_filter_size = 3;
pad_size = (avg_filter_size+1)/2;
zq = padarray(zq,[pad_size pad_size],'replicate');
zq = conv2(zq,fspecial('average',avg_filter_size),'same');
zq = zq(pad_size+1:end-pad_size,pad_size+1:end-pad_size);

figure;
surf(zq,xq(1:f:end,1:f:end),max(yq(:))-yq(1:f:end,1:f:end));
title('surface fit with griddata')
xlabel('Depth(mm)');ylabel('x (pixel)');zlabel('y (pixel)')


%% with ground truth
figure;
hold on
plot3(sparse_map_median_seq1_seq2(:,1),sparse_map_median_seq1_seq2(:,2),sparse_map_median_seq1_seq2(:,3),'r.','markersize',10)
grid on

spacing = 10;
staircase_h = [324 2000];
% staircase_w = [996+1 2343-1];
staircase_w = [1000+1 2400-1];
[X,Y] = meshgrid(staircase_w(1):spacing:staircase_w(2),...
                 staircase_h(1):spacing:staircase_h(2));

% trueDepth = 400.*(heaviside(1113-X) - heaviside(1000-X))+...
%             395.*(heaviside(1233-X) - heaviside(1113-X))+...1012
%             390.*(heaviside(1356-X) - heaviside(1233-X))+...1117
%             385.*(heaviside(1479-X) - heaviside(1356-X))+...1226
%             380.*(heaviside(1740-X) - heaviside(1479-X))+...1344
%             385.*(heaviside(1866-X) - heaviside(1740-X))+...1426
%             390.*(heaviside(1987-X) - heaviside(1866-X))+...1726
%             395.*(heaviside(2112-X) - heaviside(1987-X))+...1855  
%             400.*(heaviside(2229-X) - heaviside(2112-X))+...
%             405.*(heaviside(2400-X) - heaviside(2229-X));

trueDepth = 420.*(heaviside(1137-X) - heaviside(1000-X))+...
            410.*(heaviside(1245-X) - heaviside(1137-X))+...1012
            400.*(heaviside(1359-X) - heaviside(1245-X))+...1117
            390.*(heaviside(1479-X) - heaviside(1359-X))+...1226
            380.*(heaviside(1740-X) - heaviside(1479-X))+...1344
            390.*(heaviside(1863-X) - heaviside(1740-X))+...1426
            400.*(heaviside(1977-X) - heaviside(1863-X))+...1726
            410.*(heaviside(2094-X) - heaviside(1977-X))+...1855  
            420.*(heaviside(2199-X) - heaviside(2094-X))+...
            430.*(heaviside(2400-X) - heaviside(2199-X));



            
mesh(X,Y,trueDepth,'linewidth',1)
alpha(0)
grid on
xlabel('x (pixel)');ylabel('y (pixel)');zlabel('Depth (cm)')
legend('Estimated Depth','Ground Truth Depth')
title('Ground Truth Depth vs. Estimated Depth')


