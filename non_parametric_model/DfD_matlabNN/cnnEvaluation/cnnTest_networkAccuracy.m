clc
clear
close all
iptsetpref('ImshowBorder','tight')

net_path  = ['C:\Users\avery\Desktop\DfD\20170501ScreenCap\nothreshold\r\train234_test1\convnet_r.mat'];
load(net_path)

folder = ['C:\Users\avery\Desktop\DfD\20170501ScreenCap\nothreshold\r\train234_test1\test1\'];
test_images = dir([folder '*.jpg']);

patch_size = [20 20];

numb_of_dots = 3217; %r
% numb_of_dots = 3184; %b

target = zeros(20,numb_of_dots*20);
output = zeros(20,numb_of_dots*20);
result_list = zeros(numb_of_dots*20,2);
mean_depth_error = zeros(1,20);

off_by_5mm = 0;
channel = 1;
channel_threshold = 40;
net1 = net1r;

for i = 1: length(test_images)
    filename = test_images(i).name;
    I = im2double(imread([folder filename]));
    I_red = I(:,:,channel);

    I_red(I_red(:,:)<(channel_threshold/255)) = 0;

    lvl = graythresh(I_red);
    I_threshold = I_red > lvl;
%     I_morph = imerode(I_threshold,strel('square',2));
    I_stats = regionprops(I_threshold,'Centroid','Area');
    area_thresh  = 10;
    area_filter = [I_stats.Area]<area_thresh;
    I_stats(area_filter) = [];
    centroids = round(cat(1, I_stats.Centroid));
    
    if numb_of_dots ~= length(I_stats)
        length(I_stats)
    end
    
    [n,m] = size(I(:,:,1));
    [X,Y] = meshgrid(1:m,1:n);
    
    I = im2double(imread([folder filename]));
    I_red = I(:,:,channel);

    for j = 1: length(I_stats)
    %     filename = files(i).name;
        ((i-1)*numb_of_dots+j)/(numb_of_dots*20)*100
        I_patch = I_red(centroids(j,2)-patch_size/2+1:centroids(j,2)+patch_size/2,...
                        centroids(j,1)-patch_size/2+1:centroids(j,1)+patch_size/2);
        I_patch = uint8(I_patch.*255);


        target_depth = str2double(filename(1:3))/10;
%         scores = net1(reshape(I_patch',[400 1]));
%         output_depth = (find(scores == max(scores))-1)*0.5+38;

        output_depth = str2double(cellstr(classify(net1,I_patch)))/10;

        target_index = target_depth*2-75;
        output_index = output_depth*2-75;

        target(target_index,(i-1)*numb_of_dots+j) = 1;
        output(output_index,(i-1)*numb_of_dots+j) = 1;

        result_list((i-1)*numb_of_dots+j,1:2) = [target_depth output_depth];
        mean_depth_error(target_index) = ...
            mean_depth_error(target_index)+...
                abs(target_depth - output_depth);
    end
end


mean_depth_error = mean_depth_error./numb_of_dots;

% confusionmat(result_list(:,1),result_list(:,2))
mean_depth_error_global = mean(abs(result_list(:,1) - result_list(:,2)))
accuracy = sum(result_list(:,1) == result_list(:,2))/length(result_list)
% accuracy_no_less_than_5mm = sum(abs(result_list(:,1) - result_list(:,2))<=0.5)/length(result_list)


% figure;plot(38:47,mean_depth_error,'r.--','MarkerSize',20)
figure;plot(38:0.5:47.5,mean_depth_error,'r.--','MarkerSize',20)
title('Mean Absolute Depth Error'); xlabel('Depth (cm)'); ylabel('Error (cm)'); grid on
% hold on; plot(38:47, repmat(mean_depth_error_global,1,10),'b --','LineWidth',2);
hold on; plot(38:0.5:47.5, repmat(mean_depth_error_global,1,20),'b --','LineWidth',2);
legend('Individual mean absolute depth Error ','Global mean absolute depth error')

figure; conf = plotconfusion(target,output);
% label = ['38';'39';'40';'41';'42';'43';'44';'45';'46';'47';'  ';];
label = ['38.0';'38.5';'39.0';'39.5';'40.0';'40.5';'41.0';'41.5';'42.0';...
         '42.5';'43.0';'43.5';'44.0';'44.5';'45.0';'45.5';'46.0';'46.5';'47.0';'47.5';'    ';];
set(conf.Children(2),'XTickLabel',label)
set(conf.Children(2),'YTickLabel',label)