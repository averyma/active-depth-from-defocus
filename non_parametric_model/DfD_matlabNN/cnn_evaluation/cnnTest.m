clc
clear
close all

net_path  = ['C:\Users\avery\Desktop\DfD\20170403ScreenCap\070\train234_test1\convnet.mat'];
load(net_path)
folder = ['C:\Users\avery\Desktop\DfD\20170221ScreenCap1\' f_name 'test' num2str(i) '\'];
% [file, folder] = uigetfile({'*.jpg','All Image Files'},'Select captured image');
% if file == 0, return, end;

patches = dir([folder '*.png']);
numb_of_patches = length(patches);
patch_size = [30 30];
target = zeros(20,numb_of_patches);
output = zeros(20,numb_of_patches);
result_list = zeros(numb_of_patches,2);
mean_depth_error = zeros(1,20);

for j = 1: numb_of_patches
%     filename = files(i).name;
    filename = [folder patches(j).name];
    j/numb_of_patches*100
    I_patch = imread(filename);
    
    target_depth = str2num(patches(j).name(1:3))/10;
    output_depth = str2double(cellstr(classify(convnet,I_patch)))/10;
    
    target_index = target_depth*2-75;
    output_index = output_depth*2-75;
    
    target(target_index,j) = 1;
    output(output_index,j) = 1;
    
    result_list(j,1:2) = [target_depth output_depth];
    mean_depth_error(target_index) = ...
        mean_depth_error(target_index)+...
            abs(target_depth - output_depth);  
end

mean_depth_error = mean_depth_error./895;


confusionmat(result_list(:,1),result_list(:,2))
accuracy = sum(result_list(:,1) == result_list(:,2))/length(result_list)
mean_depth_error_global = mean(abs(result_list(:,1) - result_list(:,2)))


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


