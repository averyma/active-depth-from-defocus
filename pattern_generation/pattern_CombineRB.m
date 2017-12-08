clc
clear
close all

pattern = '_x';
root_dir = ['/Users/ama/Desktop/DfD/calibration_dot_pattern/cnn/cnn_sequential_035_full' pattern '/'];


r_1 = im2double(imread([root_dir 'cnn_r_035_1' pattern '.png']));
b_1 = im2double(imread([root_dir 'cnn_b_035_1' pattern '.png']));

r_seq = im2double(imread([root_dir 'cnn_r_035_seq' pattern '.png']));
b_seq = im2double(imread([root_dir 'cnn_b_035_seq' pattern '.png']));


rb_1 = zeros(size(r_1));
rb_seq = rb_1;

rb_1(:,:,1) = r_1(:,:,1);
rb_1(:,:,3) = b_1(:,:,3);

rb_seq(:,:,1) = r_seq(:,:,1);
rb_seq(:,:,3) = b_seq(:,:,3);

imwrite(rb_1,[root_dir 'cnn_rb_035_1' pattern '.png'])
imwrite(rb_seq,[root_dir 'cnn_rb_035_seq' pattern '.png'])

