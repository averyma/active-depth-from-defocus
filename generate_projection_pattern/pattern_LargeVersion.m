cnn_r_1 = im2double(imread('/Users/ama/Desktop/DfD/calibration_dot_pattern/cnn/cnn_sequential_070r/cnn_r_070_1.png'));
cnn_r_2 = im2double(imread('/Users/ama/Desktop/DfD/calibration_dot_pattern/cnn/cnn_sequential_070r/cnn_r_070_2.png'));
cnn_r_3 = im2double(imread('/Users/ama/Desktop/DfD/calibration_dot_pattern/cnn/cnn_sequential_070r/cnn_r_070_3.png'));
cnn_r_4 = im2double(imread('/Users/ama/Desktop/DfD/calibration_dot_pattern/cnn/cnn_sequential_070r/cnn_r_070_4.png'));
cnn_r_5 = im2double(imread('/Users/ama/Desktop/DfD/calibration_dot_pattern/cnn/cnn_sequential_070r/cnn_r_070_seq.png'));


cnn_b_1 = im2double(imread('/Users/ama/Desktop/DfD/calibration_dot_pattern/cnn/cnn_sequential_070b/cnn_b_070_1.png'));
cnn_b_2 = im2double(imread('/Users/ama/Desktop/DfD/calibration_dot_pattern/cnn/cnn_sequential_070b/cnn_b_070_2.png'));
cnn_b_3 = im2double(imread('/Users/ama/Desktop/DfD/calibration_dot_pattern/cnn/cnn_sequential_070b/cnn_b_070_3.png'));
cnn_b_4 = im2double(imread('/Users/ama/Desktop/DfD/calibration_dot_pattern/cnn/cnn_sequential_070b/cnn_b_070_4.png'));
cnn_b_5 = im2double(imread('/Users/ama/Desktop/DfD/calibration_dot_pattern/cnn/cnn_sequential_070b/cnn_b_070_seq.png'));

se = strel('sphere',1);
% se = ones(3);
cnn_r_1(:,:,1) = imdilate(cnn_r_1(:,:,1),se);
cnn_r_2(:,:,1) = imdilate(cnn_r_2(:,:,1),se);
cnn_r_3(:,:,1) = imdilate(cnn_r_3(:,:,1),se);
cnn_r_4(:,:,1) = imdilate(cnn_r_4(:,:,1),se);
cnn_r_5(:,:,1) = imdilate(cnn_r_5(:,:,1),se);
cnn_b_1(:,:,3) = imdilate(cnn_b_1(:,:,3),se);
cnn_b_2(:,:,3) = imdilate(cnn_b_2(:,:,3),se);
cnn_b_3(:,:,3) = imdilate(cnn_b_3(:,:,3),se);
cnn_b_4(:,:,3) = imdilate(cnn_b_4(:,:,3),se);
cnn_b_5(:,:,3) = imdilate(cnn_b_5(:,:,3),se);


save_dir = '/Users/ama/Desktop/DfD/calibration_dot_pattern/cnn/cnn_v2/';

imwrite(cnn_r_1,[save_dir 'cnn_v2_r_1.png']);
% imwrite(cnn_r_2,[save_dir 'cnn_v2_r_2.png']);
% imwrite(cnn_r_3,[save_dir 'cnn_v2_r_3.png']);
% imwrite(cnn_r_4,[save_dir 'cnn_v2_r_4.png']);
% imwrite(cnn_r_5,[save_dir 'cnn_v2_r_5.png']);
imwrite(cnn_b_1,[save_dir 'cnn_v2_b_1.png']);
% imwrite(cnn_b_2,[save_dir 'cnn_v2_b_2.png']);
% imwrite(cnn_b_3,[save_dir 'cnn_v2_b_3.png']);
% imwrite(cnn_b_4,[save_dir 'cnn_v2_b_4.png']);
% imwrite(cnn_b_5,[save_dir 'cnn_v2_b_5.png']);

