clc
clear
close all
iptsetpref('ImshowBorder','tight')

test_name = 'b_train234_ff_50x50';
net_path  = ['F:\DfD\ScreenCap\20170728ScreenCap\b\' test_name '\net_' test_name '.mat'];
load(net_path);
net = convnet;

root_dir = 'F:\DfD\ScreenCap\20170728ScreenCap\b\';
result_dir = ['F:\DfD\ScreenCap\20170728ScreenCap\b\' test_name '\result\'];
mkdir(result_dir)
color = 'b';
channel = 3;
start_depth = 40;
numb_of_depth = 16;
patch_size = 50;
plot_size = 20;
channel_threshold = 170;

target = [];
output = [];
result_list = [];
mean_depth_error = zeros(1,numb_of_depth);

for i = 1:numb_of_depth
    folder = [root_dir color '_' int2str(start_depth+i-1) '\'];
    files = dir([folder '*.png']);
    d1 = im2double(imread([folder files(5).name]));
    d2 = im2double(imread([folder files(6).name]));
    d3 = im2double(imread([folder files(7).name]));
    f1 = im2double(imread([folder files(8).name]));
    f2 = im2double(imread([folder files(9).name]));
    f3 = im2double(imread([folder files(10).name]));
    d = (d1+d2+d3)./3;
    f = (f1+f2+f3)./3;

    r = im2double(imread([folder files(1).name]));
    img_ff = (r-d)./(f-d);
    img = img_ff(:,:,channel);
    img_threshold = img;
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
    [n,m] = size(img(:,:,1));
    [X,Y] = meshgrid(1:m,1:n);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    target = [target zeros(numb_of_depth,numb_of_dots)];
    output = [output zeros(numb_of_depth,numb_of_dots)];
    result_list = [result_list; zeros(numb_of_dots,2)];
    class_map = r;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for j = 1:numb_of_dots
        
        if (centroids(j,2)-patch_size/2-1)>0 && ...
           (centroids(j,2)+patch_size/2)<n && ...
           (centroids(j,1)-patch_size/2-1)>0 && ...
           (centroids(j,1)+patch_size/2)<m 
            
            i*1000+j/numb_of_dots*100
            
            img_patch = img_ff(centroids(j,2)-patch_size/2+1:centroids(j,2)+patch_size/2,...
                            centroids(j,1)-patch_size/2+1:centroids(j,1)+patch_size/2,channel);

%             result_name = [color '_' int2str(start_depth+i-1) '_' int2str(k) '_' int2str(j)];
%             imwrite(img_patch,[result_path result_name '.png']);
            img_patch = uint8(img_patch.*255);

            target_depth = str2double(files(1).name(3:4));
    %         scores = net1(reshape(I_patch',[400 1]));
    %         output_depth = (find(scores == max(scores))-1)*0.5+38;

            output_depth = str2double(cellstr(classify(net,img_patch)));

            target_index = target_depth-start_depth+1;
            output_index = output_depth-start_depth+1;

            target(target_index,(size(target,2)-numb_of_dots)+j) = 1;
            output(output_index,(size(output,2)-numb_of_dots)+j) = 1;

            result_list((size(output,2)-numb_of_dots)+j,1:2) = [target_depth output_depth];
            mean_depth_error(target_index) = ...
                mean_depth_error(target_index)+...
                    abs(target_depth - output_depth);
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
            if target_depth == output_depth
                % if same, green
                class_map(centroids(j,2)-plot_size/2+1:centroids(j,2)+plot_size/2,...
                        centroids(j,1)-plot_size/2+1:centroids(j,1)+plot_size/2,2) = 1;
            elseif abs(target_depth-output_depth)==1
                % if off by 1cm, cyan
                class_map(centroids(j,2)-plot_size/2+1:centroids(j,2)+plot_size/2,...
                          centroids(j,1)-plot_size/2+1:centroids(j,1)+plot_size/2,2:3) = 1;
            elseif abs(target_depth-output_depth)== 2
                % if off by 2cm, yellow
                class_map(centroids(j,2)-plot_size/2+1:centroids(j,2)+plot_size/2,...
                          centroids(j,1)-plot_size/2+1:centroids(j,1)+plot_size/2,1:2) = 1;
            else
                % if off by 2cm+, red
                class_map(centroids(j,2)-plot_size/2+1:centroids(j,2)+plot_size/2,...
                          centroids(j,1)-plot_size/2+1:centroids(j,1)+plot_size/2,1) = 1;
            end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
        end
    end
    figure;imshow(class_map);
    str = [int2str(start_depth+i-1) 'cm;' '  Green: correct, Cyan: off by 1cm, Yellow: off by 2cm, Red: off by 2cm+']
    annotation('textbox',[0.01 0.01 0.05 0.05],'String',str,'FitBoxToText','on','Color','red','FontSize',20);
    export_fig([result_dir 'class_map'],'-pdf','-append')
    close 
end

mean_depth_error = mean_depth_error./(size(target,2)/numb_of_depth);

% confusionmat(result_list(:,1),result_list(:,2))
mean_depth_error_global = mean(abs(result_list(:,1) - result_list(:,2)))
accuracy = sum(result_list(:,1) == result_list(:,2))/length(result_list)
% accuracy_no_less_than_5mm = sum(abs(result_list(:,1) - result_list(:,2))<=0.5)/length(result_list)

%% plot mean depth error/global depth error
figure;plot(start_depth:start_depth+numb_of_depth-1,mean_depth_error,'r.--','MarkerSize',20)
title('Mean Absolute Depth Error'); xlabel('Depth (cm)'); ylabel('Error (cm)'); grid on
hold on; plot(start_depth:start_depth+numb_of_depth-1, repmat(mean_depth_error_global,1,numb_of_depth),'b --','LineWidth',2);
legend('Individual mean absolute depth Error ','Global mean absolute depth error')
print([result_dir 'mean_depth_error'],'-dpng','-noui')

%% plot confusion matrix
figure('units','normalized','outerposition',[0 0 1 1]);
conf = plotconfusion(target,output);
label = int2str([start_depth:start_depth+numb_of_depth-1]'); label = [label;'  '];
set(conf.Children(2),'XTickLabel',label)
set(conf.Children(2),'YTickLabel',label)
print([result_dir 'conf'],'-dpng','-noui')