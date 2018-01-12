Camera Calib: 
 - reprojection error: 0.819928
 - K:
[3486.597883630046, 0, 1298.387216783769;
  0, 3875.943573309087, 930.2202340699594;
  0, 0, 1]
 - kc: [0.1769730743674916, -0.6413079920341588, -0.026247226750387, 0.001545285804795444, 0]

Projector Calib: 
 - reprojection error: 0.405213
 - K:
[3486.378956639671, 0, 550.1477223619765;
  0, 3523.27793014461, 344.7126487325629;
  0, 0, 1]
 - kc: [0.03042162968101235, 10.08067957731273, -0.04736997132628822, 0.01504592660874691, 0]

Stereo Calib: 
 - reprojection error: 0.95767
 - R:
[0.999995916794002, 0.001655873269165871, -0.002329051102910253;
  -0.002387316791894311, 0.9320305446448335, -0.3623718595139392;
  0.001570704892284031, 0.3623759400577962, 0.9320306920661839]
 - T:
[42.23591195729403;
  346.5805940420644;
  1225.517915672003]

% clear
% clc
% close all
%% Projector-Camera Stereo calibration parameters:

%%
intrinsics_cam1 = [3486.597883630046, 0, 1298.387216783769;
  0, 3875.943573309087, 930.2202340699594;
  0, 0, 1];
% radialD_cam1 = [kc_left(1) kc_left(2) kc_left(3)];
% tangentialD_cam1 = [kc_left(4) kc_left(5)];
% imageSize_cam1 = [1944 2592];
cameraParameters1 = cameraParameters('IntrinsicMatrix' ,intrinsics_cam1,...
                                     'RadialDistortion', radialD_cam1,...
                                     'TangentialDistortion',tangentialD_cam1);
%%                                 
intrinsics_cam2 = [3486.378956639671, 0, 550.1477223619765;
  0, 3523.27793014461, 344.7126487325629;
  0, 0, 1]
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