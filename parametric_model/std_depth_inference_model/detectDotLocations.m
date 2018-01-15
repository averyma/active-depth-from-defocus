clc
close all
clear

%% read image
I = im2double(imread('edge.png'));
I = I(:,:,1);
%  I(1,:)=[]; I(end,:)=[];
% figure;imshow(I)

%% thresholding
lvl = graythresh(I);
I_threshold = I > lvl;
% I_threshold(1,:) = 0; I_threshold(end,:) = 0;
% figure;imshow(I_threshold,[])

%% morpholocial operation
I_morph = imerode(I_threshold,strel('square',8));
% I_morph = imdilate(I_threshold,strel('square',3));
figure;imshow(I_morph,[])

%% getting centroid/area/radious using regionprops
% I_stats = regionprops(I_morph,'Area','Centroid','MajorAxisLength','MinorAxisLength');
I_stats = regionprops(I_morph,'Centroid');
centroids = cat(1, I_stats.Centroid);
centroids = round(centroids);
% areas = cat(1, I_stats.Area);
% majorAxisLength = cat(1, I_stats.MajorAxisLength);
% minorAxisLength = cat(1, I_stats.MajorAxisLength);
% diameters = mean([majorAxisLength minorAxisLength],2);
% radii = diameters/2;
numb_of_dots = size(I_stats,1);

%% creating patch for each blurry dot
%%%% https://www.mathworks.com/matlabcentral/newsreader/view_thread/173627%%%%%%%%%%%
%%%%%%%%%%%%%%%find shortest distance pair within a point set%%%%%%%%%%%%%%
p = centroids;
tri=delaunay(p(:,1),p(:,2));
d2fun = @(k,l) sum((p(k,:)-p(l,:)).^2,2);
d2tri = @(k) [d2fun(tri(k,1),tri(k,2)) ...
              d2fun(tri(k,2),tri(k,3)) ...
              d2fun(tri(k,3),tri(k,1))];
dtri=cell2mat(arrayfun(@(k) d2tri(k),...
              (1:size(tri,1))','UniformOutput',0));
d=sqrt(min(dtri(:)));

%%%%%%%%%%%%%%%uncomment this section to view centroid/circle on I%%%%%%%%%%%%%%%%%%%
figure;
% imshow(imadjust(I));
imshow(I);
hold on
for i = 1:numb_of_dots
    plot(centroids(i,1),centroids(i,2),'r.','markersize',20);
    ang=0:0.001:2*pi; 
    xp=d/2*cos(ang);
    yp=d/2*sin(ang);
    plot(centroids(i,1)+xp,centroids(i,2)+yp,'r','LineWidth',4);    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[n,m] = size(I);
[X,Y] = meshgrid(1:m,1:n);
I_std_map = zeros(size(I));

tic
for i = 1:numb_of_dots
    i
    dist_from_centroid =  sqrt((X-centroids(i,1)).^2 + (Y-centroids(i,2)).^2);
    dist_from_centroid(dist_from_centroid>d/2)=0;
    dist_from_centroid(dist_from_centroid~=0)=1;
    dist_from_centroid(centroids(i,2),centroids(i,1))=1;
    
    I_mask = dist_from_centroid;
    % note: in the original captured image, it appears that the pixel at
    % top and bottom row are not the actual pixel intensity, therefore, we
    % manually change them to 0
    I_top_bottom_color_edit = I;
    I_top_bottom_color_edit(1,:) = 0;
    I_top_bottom_color_edit(end,:) = 0; 
    
    I_patch = I_mask.* I_top_bottom_color_edit;
    
%     figure,imshow(I_patch),hold on
    
    I_patch = round(I_patch *10000); % using entire image as patch
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% small patch
%     if centroids(i,2)-round(d/2)<0
%         y_lower = 1;
%     else
%         y_lower = centroids(i,2)-round(d/2);
%     end
%     
%     if centroids(i,2)+round(d/2)>n
%         y_upper = n;
%     else
%         y_upper = centroids(i,2)+round(d/2);
%     end
%     
%     if centroids(i,1)-round(d/2)<0
%         x_lower = 1;
%     else
%         x_lower = centroids(i,1)-round(d/2);
%     end
%     
%     if centroids(i,1)-round(d/2)>m
%         x_upper = m;
%     else
%         x_upper = centroids(i,1)+round(d/2);
%     end
%     
% %     plot(x_lower,y_lower,'r.');
% %     plot(x_upper,y_upper,'b.');
%     
%     I_patch = I_patch( y_lower : y_upper, x_lower : x_upper);
% %     figure,imshow(I_patch,[])
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    stack_of_xy = [];
%     tic
    for x = 1:size(I_patch,2)
        for y = 1:size(I_patch,1)
            if I_patch(y,x)~=0
                cur_stack = repmat([y,x],I_patch(y,x),1);
                stack_of_xy = [cur_stack; stack_of_xy];
            end
        end
    end    
%     toc
    std_of_xy = std(stack_of_xy);
    mean_of_xy = round(mean(stack_of_xy));
    I_std_map(mean_of_xy(2),mean_of_xy(1))= mean(std_of_xy);
%     close all

end
toc

%% plot
% figure
% imshow(I_threshold)
% figure
% imshow(I_morph)
% hold on
% plot(centroids(:,1),centroids(:,2),'r.')
% 
% figure,
% imshow(I)
% hold on
% plot(centroids(:,1),centroids(:,2),'r.')
figure; plot3(X,Y,I_std_map,'r.')
