clc
clear
close all

%% poisson disc sampling approach
proj_rez = [1080 1920];
% proj_rez = [360 640];
% numb_pixels = proj_rez(1) * proj_rez(2);

dot_pattern = zeros([proj_rez 3]);

% RGB 3 channel: 
% R: index; 
% G: index + numb_pixels; 
% B: index + 2*numb_pixels

color = 1:3;
%center dot
dot_pattern(proj_rez(1)/2, proj_rez(2)/2,color) = 1; 
% 8 dots 
for spread = 50:50:400
dot_pattern(proj_rez(1)/2-spread, proj_rez(2)/2-spread,color) = 1; 
dot_pattern(proj_rez(1)/2+spread, proj_rez(2)/2+spread,color) = 1; 
dot_pattern(proj_rez(1)/2+spread, proj_rez(2)/2-spread,color) = 1; 
dot_pattern(proj_rez(1)/2-spread, proj_rez(2)/2+spread,color) = 1;
dot_pattern(proj_rez(1)/2, proj_rez(2)/2+spread,color) = 1;
dot_pattern(proj_rez(1)/2-spread, proj_rez(2)/2,color) = 1;
dot_pattern(proj_rez(1)/2+spread, proj_rez(2)/2,color) = 1;
dot_pattern(proj_rez(1)/2, proj_rez(2)/2-spread,color) = 1;
end


se = strel('square',1);
% dot = fspecial('gaussian',[9 9],1); dot=dot./max(dot(:));
dot_pattern = imdilate(dot_pattern,se);

figure(1), imshow(dot_pattern)

