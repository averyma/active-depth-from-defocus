clear
clc
close 

pattern = '7x7cross'
dir = ['/Users/ama/Desktop/DfD/calibration_dot_pattern/cnn/cnn_sequential_035_full_' pattern '/']
file = 'cnn_r_035_';
channel = 1;
% se = [0 0 1 0 0; 0 0 1 0 0 ; 1 1 1 1 1; 0 0 1 0 0; 0 0 1 0 0];
se = [0 0 0 1 0 0 0;...
      0 0 0 1 0 0 0;...
      0 0 0 1 0 0 0;...
      1 1 1 1 1 1 1;...
      0 0 0 1 0 0 0;...
      0 0 0 1 0 0 0;...
      0 0 0 1 0 0 0;];

for i = 1:4
    img = im2double(imread([dir file num2str(i) '.png']));
    delete([dir file num2str(i) '.png']);
    img(:,:,channel) = imdilate(img(:,:,channel),se);
    imwrite(img,[dir file num2str(i) '_' pattern '.png'])
end

img = im2double(imread([dir file 'seq.png']));
delete([dir file 'seq.png']);
img(:,:,channel) = imdilate(img(:,:,channel),se);
imwrite(img,[dir file 'seq_' pattern '.png'])



