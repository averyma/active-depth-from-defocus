clc
close all force
clear
% choose one file in selected folder to generate sparse map, blue and red
% calibration files should also be in the selected folder

%% read image file and blue/red depth_eig files 
[file, folder] = uigetfile({'*.jpg','All Image Files'},'Select captured image');
if file == 0, return, end;

list = dir([folder '*.mat']);
load([folder list(1).name]);
depth_eig_blue = depth_eig;
load([folder list(2).name]);
depth_eig_red = depth_eig;
clearvars depth_eig
clearvars list

%% construct curve fit for the eigenvalue vs depth model
curve_red = fit(depth_eig_red(:,2),depth_eig_red(:,1),'poly3');
curve_blue = fit(depth_eig_blue(:,2),depth_eig_blue(:,1),'poly3');


figure; 
hold on
grid on
plot(depth_eig_red(:,2),depth_eig_red(:,1),'r.','MarkerSize',20)
plot(depth_eig_blue(:,2),depth_eig_blue(:,1),'b.','MarkerSize',20)
plot(curve_red,'r')
plot(curve_blue,'b')
xlabel('Major Eigenvalue of Covariance'); ylabel('Depth (cm)');
title('Major Eigenvalue of Covariance vs. Depth')
legend('Measurement (red)','Measurement (blue)',...
       'Curve Fit Result (red)','Curve Fit Result (blue)')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I = imread([folder file]);
I = im2double(I);
% crop top and bottom row
I(1,:,:) = [];
I(end,:,:) = [];

%% red
% otsu threshold
I_red = I(:,:,1);
lvl_red = graythresh(I_red);
I_red_threshold = I_red > lvl_red;
% morphological operation
% I_red_morph = imerode(I_red_threshold,strel('square',6));
% getting centroids
I_stats = regionprops(I_red_threshold,'Centroid');
centroids = round(cat(1, I_stats.Centroid));
numb_of_dots = length(I_stats);
depth_red = centroids;

% find shortest distance pair within a point set

[d] = findShortestDistance(centroids);
[n,m] = size(I(:,:,1));
%         figure
%         hold on

%%%%%%%%%%%% uncomment this section to verify centroids/radius %%%%%%%%%%%%
        figure;
        imshow(I);
        hold on
        for n = 1:numb_of_dots
            plot(centroids(n,1),centroids(n,2),'r.','markersize',15);
            ang=0:0.001:2*pi; 
            xp=d/2*cos(ang);
            yp=d/2*sin(ang);
            plot(centroids(n,1)+xp,centroids(n,2)+yp,'r','LineWidth',2);    
        end
%         close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:numb_of_dots
%             centroids(j,:)
%             plot(centroids(j,1),centroids(j,2),'r.');
%             axis([0 m 0 n])
    % outlier detection
        i/numb_of_dots*100
    if (centroids(i,2)-round(d/2)-1)>0 && ...
       (centroids(i,2)+round(d/2))<n && ...
       (centroids(i,1)-round(d/2)-1)>0 && ...
       (centroids(i,1)+round(d/2))<m 
        
        [X,Y] = meshgrid(1:m,1:n);
        dist_from_centroid =  sqrt((X-centroids(i,1)).^2 + (Y-centroids(i,2)).^2);
        dist_from_centroid(dist_from_centroid>d/2)=0;
        dist_from_centroid(dist_from_centroid~=0)=1;
        dist_from_centroid(centroids(i,2),centroids(i,1))=1;

        I_mask = dist_from_centroid;
        I_patch = I_mask .* I_red;
        I_patch = I_patch(centroids(i,2)-round(d/2)+1:centroids(i,2)+round(d/2),...
                          centroids(i,1)-round(d/2)+1:centroids(i,1)+round(d/2));  
                      
        % better represent the I_patch
        findMin = I_patch;
        findMin(findMin==0) = inf;
        findMin = min(findMin(:));
        I_patch(I_patch ==0) = findMin;
       
        %% calculate eigenvalue of the patch
        I_patch = I_patch - min(I_patch(:));
        I_patch = I_patch./max(I_patch(:));
        threshold = 0.15;
        I_patch(I_patch<threshold) =0;
        I_patch = I_patch./max(I_patch(:));


        [X Y] = meshgrid(1:size(I_patch,1),1:size(I_patch,2));
        I_patch = round(I_patch *10000);
        sampleConfig = [X(:) Y(:) I_patch(:)];
        sampleSet = zeros(sum(I_patch(:)),2);
        cursor = 1;
        for j = 1:length(sampleConfig)
                if sampleConfig(j,3)~=0
                    sampleSet(cursor:cursor+sampleConfig(j,3)-1,:)=repmat(sampleConfig(j,1:2),sampleConfig(j,3),1);
                    cursor = cursor + sampleConfig(j,3);
                end
        end

    %     figure
    %     [X,Y] = meshgrid(1:size(I_patch,1),1:size(I_patch,2));
    %     surf(X,Y,I_patch)
    %     figure
    %     imshow(I_patch,[])

        cov_xy = cov(sampleSet);
        eig_cov = eig(cov_xy);
        max_eig = max(eig_cov);
        depth_red(i,3) = curve_red(max_eig);
    end
end
depth_red = depth_red(depth_red(:,3)~=0,:);

%% blue
% otsu threshold
I_blue = I(:,:,3);
lvl_blue = graythresh(I_blue);
I_blue_threshold = I_blue > lvl_blue;
% morphological operation
I_blue_morph = imerode(I_blue_threshold,strel('square',8));
% getting centroids
I_stats = regionprops(I_blue_morph,'Centroid');
centroids = round(cat(1, I_stats.Centroid));
numb_of_dots = length(I_stats);
depth_blue = centroids;

% find shortest distance pair within a point set

[d] = findShortestDistance(centroids);
[n,m] = size(I(:,:,1));
%         figure
%         hold on

%%%%%%%%%%%% uncomment this section to verify centroids/radius %%%%%%%%%%%%
%         figure;
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

for i = 1:numb_of_dots
%             centroids(j,:)
%             plot(centroids(j,1),centroids(j,2),'r.');
%             axis([0 m 0 n])
    % outlier detection
        i/numb_of_dots*100
    if (centroids(i,2)-round(d/2)-1)>0 && ...
       (centroids(i,2)+round(d/2))<n && ...
       (centroids(i,1)-round(d/2)-1)>0 && ...
       (centroids(i,1)+round(d/2))<m 
        
        [X,Y] = meshgrid(1:m,1:n);
        dist_from_centroid =  sqrt((X-centroids(i,1)).^2 + (Y-centroids(i,2)).^2);
        dist_from_centroid(dist_from_centroid>d/2)=0;
        dist_from_centroid(dist_from_centroid~=0)=1;
        dist_from_centroid(centroids(i,2),centroids(i,1))=1;

        I_mask = dist_from_centroid;
        I_patch = I_mask .* I_blue;
        I_patch = I_patch(centroids(i,2)-round(d/2)+1:centroids(i,2)+round(d/2),...
                          centroids(i,1)-round(d/2)+1:centroids(i,1)+round(d/2));  
        
        % better represent the I_patch
        findMin = I_patch;
        findMin(findMin==0) = inf;
        findMin = min(findMin(:));
        I_patch(I_patch ==0) = findMin;
        
        %% calculate eigenvalue of the patch
        I_patch = I_patch - min(I_patch(:));
        I_patch = I_patch./max(I_patch(:));
        threshold = 0.15;
        I_patch(I_patch<threshold) =0;
        I_patch = I_patch./max(I_patch(:));


        [X Y] = meshgrid(1:size(I_patch,1),1:size(I_patch,2));
        I_patch = round(I_patch *10000);
        sampleConfig = [X(:) Y(:) I_patch(:)];
        sampleSet = zeros(sum(I_patch(:)),2);
        cursor = 1;
        for j = 1:length(sampleConfig)
                if sampleConfig(j,3)~=0
                    sampleSet(cursor:cursor+sampleConfig(j,3)-1,:)=repmat(sampleConfig(j,1:2),sampleConfig(j,3),1);
                    cursor = cursor + sampleConfig(j,3);
                end
        end

    %     figure
    %     [X,Y] = meshgrid(1:size(I_patch,1),1:size(I_patch,2));
    %     surf(X,Y,I_patch)
    %     figure
    %     imshow(I_patch,[])

        cov_xy = cov(sampleSet);
        eig_cov = eig(cov_xy);
        max_eig = max(eig_cov);
        depth_blue(i,3) = curve_blue(max_eig);
    end
end
depth_blue = depth_blue(depth_blue(:,3)~=0,:);

% depth_blue((depth_blue(:,3)<30),:) = [];
% depth_red((depth_red(:,3)<30),:) = [];


%% plot
figure;
hold on
grid on
spacing = 50;
% [X_p,Y_p] = meshgrid(1:spacing:m,1:spacing:n); % X_p, Y_p for mesh plotting purpose
% trueDepth = (-0.0125*X_p+50).*heaviside(1650-X_p)+...
%             (0.0138*X_p+7.2).*(heaviside(X_p)-heaviside(1650-X_p));
% mesh(X_p,Y_p,trueDepth,'linewidth',1)
% alpha(0)
plot3(depth_blue(:,1),depth_blue(:,2),depth_blue(:,3),'b.','markersize', 20)
plot3(depth_red(:,1),depth_red(:,2),depth_red(:,3)+1.5,'r.','markersize', 20)
xlabel('x (pixel)');ylabel('y (pixel)');zlabel('Depth (cm)')
legend('Ground Truth Depth','Estimated Depth (blue)','Estimated Depth (red)')
title('Ground Truth Depth vs. Estimated Depth')


%%
[xq,yq] = meshgrid(1:170:m,1:170:n);
vq = griddata([depth_blue(:,1);depth_red(:,1)],...
                      [depth_blue(:,2);depth_red(:,2)],...
                      [depth_blue(:,3);depth_red(:,3)],xq,yq,'cubic');
figure
grid on
hold on
surf(xq,yq,vq,'EdgeColor','none','LineStyle','none');
surf(X_p,Y_p,trueDepth,'EdgeColor','none','LineStyle','none','linewidth',1);
colormap(ax,'winter')

plot3([depth_blue(:,1);depth_red(:,1)],...
      [depth_blue(:,2);depth_red(:,2)],...
      [depth_blue(:,3);depth_red(:,3)],'r.','markersize',20)
  

  
  