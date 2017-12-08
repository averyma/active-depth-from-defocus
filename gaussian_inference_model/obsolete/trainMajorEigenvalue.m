clc
close all force
clear

[file, folder] = uigetfile({'*.png','All Image Files'},'Select captured image');
if file == 0, return, end;

files = dir([folder '*.png']);
list = dir([folder '*.mat']);
load([folder list.name]);

if exist('train_blue','var')
    train_list = train_blue;
else
    train_list = train_red;
end

total_files = length(files);

depth_range = [train_list(1).depth train_list(end).depth];

depth_eig = zeros(depth_range(2)-depth_range(1)+1,3);
depth_eig(:,1) = depth_range(1):depth_range(2);

for i = 1:total_files
    i/total_files*100
    filename = files(i).name;
    true_depth = train_list(strcmp({train_list.name}, filename)==1).depth;
    I_patch = im2double(imread([folder filename]));
    
    I_patch = I_patch - min(I_patch(:));
    I_patch = I_patch./max(I_patch(:));
    threshold = 0.15;
    I_patch(I_patch<threshold) =0;
    I_patch = I_patch./max(I_patch(:));
    
    
    [X Y]=meshgrid(1:size(I_patch,1),1:size(I_patch,2));
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
    update_max_eig = depth_eig(depth_eig(:,1)==true_depth(1),2) + max_eig;
    depth_eig(depth_eig(:,1)==true_depth(1),2) = update_max_eig;
    update_counter = depth_eig(depth_eig(:,1)==true_depth(1),3) + 1;
    depth_eig(depth_eig(:,1)==true_depth(1),3) = update_counter;   
end

depth_eig(:,2) = depth_eig(:,2)./depth_eig(:,3); 
depth_eig(:,3) = [];

figure;
plot(depth_eig(:,1),depth_eig(:,2));

if exist('train_blue','var')
    save([folder 'majorEigen_blue.mat'],'depth_eig')
else
    save([folder 'majorEigen_red.mat'],'depth_eig')
end


