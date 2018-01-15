clc
clear
close all

%% poisson disc sampling approach
proj_rez = [1080 1920];
numb_pixels = proj_rez(1) * proj_rez(2);
dot_density = 0.10*0.01;
numb_dots = round(proj_rez(1)*proj_rez(2)*dot_density);

% use pdisk2 function to generate dot coooridnates and round it to integers
[dot_location_r min_r] = pdisk2(proj_rez, numb_dots);
dot_location_r = ceil(dot_location_r);
dot_index_r = sub2ind([proj_rez 3],dot_location_r(:,1),dot_location_r(:,2));


%%%%%%% unifrom sampling the dot_location_r

% [dot_location_b idx_b] = datasample(dot_location_r,floor(size(dot_location_r,1)/2),'Replace',false);
% idx_r = setdiff([1:size(dot_location_r,1)],idx_b);
% dot_location_r = dot_location_r(idx_r,:);
% dot_index_r = sub2ind([proj_rez 3],dot_location_r(:,1),dot_location_r(:,2));

%%%%%%%

% [dot_location_b min_b] = pdisk2_b(proj_rez,dot_location_r);
[dot_location_b min_b] = pdisk2(proj_rez, numb_dots);
dot_location_b = ceil(dot_location_b);
dot_index_b = sub2ind([proj_rez 3],dot_location_b(:,1),dot_location_b(:,2));

dot_pattern = zeros([proj_rez 3]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RGB 3 channel: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% R: index; 
% G: index + numb_pixels; 
% B: index + 2*numb_pixels

dot_pattern(dot_index_r) = 1;
% dot_pattern(dot_index_r(2:2:end) + 2*numb_pixels) = 1;
dot_pattern(dot_index_b + 2*numb_pixels) = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

se = strel('square',1); % use 15 for single b and r
dot_pattern = imdilate(dot_pattern,se);

figure(1), imshow(dot_pattern)
% figure(2), imshow(dot_pattern(:,:,1)==1)
% figure(3), imshow(dot_pattern(:,:,3)==1)

% set(1,'menubar','none')
% set(1,'position',[2400 0 size(dot_pattern,2) size(dot_pattern,1)]);