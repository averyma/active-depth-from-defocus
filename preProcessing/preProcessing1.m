% clear
% clc
% close all
%% Projector-Camera Stereo calibration parameters:

% Intrinsic parameters of camera:
fc_left = [ 3486.597884 3875.943573 ]; % Focal Length
cc_left = [ 1298.387217 930.220234 ]; % Principal point
alpha_c_left = [ 0.000000 ]; % Skew
kc_left = [ 0.176973 -0.641308 -0.026247 0.001545 0.000000 ]; % Distortion

% Intrinsic parameters of projector:
fc_right = [ 3486.378957 3523.277930 ]; % Focal Length
cc_right = [ 550.147722 344.712649 ]; % Principal point
alpha_c_right = [ 0.000000 ]; % Skew
kc_right = [ 0.030422 10.080680 -0.047370 0.015046 0.000000 ]; % Distortion

% Extrinsic parameters (position of projector wrt camera):
% om = [ 0.370814 -0.001995 -0.002069 ]; % Rotation vector
T = [ 42.235912 346.580594 1225.517916 ]; % Translation vector

%%
intrinsics_cam1 = [fc_left(1) 0 0;
                   0 fc_left(2) 0;
                   cc_left(1) cc_left(2) 1];
radialD_cam1 = [kc_left(1) kc_left(2) kc_left(3)];
tangentialD_cam1 = [kc_left(4) kc_left(5)];
% imageSize_cam1 = [1944 2592];
cameraParameters1 = cameraParameters('IntrinsicMatrix' ,intrinsics_cam1,...
                                     'RadialDistortion', radialD_cam1,...
                                     'TangentialDistortion',tangentialD_cam1);
%%                                 
intrinsics_cam2 = [fc_right(1) 0 0;
                   0 fc_right(2) 0;
                   cc_right(1) cc_right(2) 1];
radialD_cam2 = [kc_right(1) kc_right(2) kc_right(3)];
tangentialD_cam2 = [kc_right(4) kc_right(5)];
% imageSize_cam2 = [1080 1920];
cameraParameters2 = cameraParameters('IntrinsicMatrix' ,intrinsics_cam2,...
                                     'RadialDistortion', radialD_cam2,...
                                     'TangentialDistortion',tangentialD_cam2);
                                 
                                 
%%
rotationOfCamera2 = rotationVectorToMatrix(om);
translationOfCamera2 = T;

stereoParams = stereoParameters(cameraParameters2,cameraParameters1,...
                                rotationOfCamera2,translationOfCamera2);

I1 = imread('/Users/ama/Desktop/DfD/proj_cam_calibration/20170609/1/01.png');
% I1 = I1(:,:,3);
I2 = imread('/Users/ama/Desktop/DfD/calibration_dot_pattern/cnn/cnn_sequential_070b/cnn_b_070_1.png');
[J1,J2] = rectifyStereoImages(I1,I1,stereoParams);
figure;imshow(J1)