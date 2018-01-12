imagePoints = zeros(70,2,2,2);

%%
fid = fopen('/Users/ama/Desktop/DfD/proj_cam_calibration/20170609/cam_00.txt');
cam_00 = fscanf(fid,'%f',[2 70])';
imagePoints(:,:,1,1) = cam_00;

fid = fopen('/Users/ama/Desktop/DfD/proj_cam_calibration/20170609/cam_01.txt');
cam_01 = fscanf(fid,'%f',[2 70])';
imagePoints(:,:,2,1) = cam_01;

fid = fopen('/Users/ama/Desktop/DfD/proj_cam_calibration/20170609/cam_02.txt');
cam_02 = fscanf(fid,'%f',[2 70])';
imagePoints(:,:,3,1) = cam_02;

fid = fopen('/Users/ama/Desktop/DfD/proj_cam_calibration/20170609/cam_03.txt');
cam_03 = fscanf(fid,'%f',[2 70])';
imagePoints(:,:,4,1) = cam_03;

fid = fopen('/Users/ama/Desktop/DfD/proj_cam_calibration/20170609/cam_04.txt');
cam_04 = fscanf(fid,'%f',[2 70])';
imagePoints(:,:,5,1) = cam_04;

fid = fopen('/Users/ama/Desktop/DfD/proj_cam_calibration/20170609/cam_05.txt');
cam_05 = fscanf(fid,'%f',[2 70])';
imagePoints(:,:,6,1) = cam_05;

%%
fid = fopen('/Users/ama/Desktop/DfD/proj_cam_calibration/20170609/proj_00.txt');
proj_00 = fscanf(fid,'%f',[2 70])';
imagePoints(:,:,1,2) = proj_00;

fid = fopen('/Users/ama/Desktop/DfD/proj_cam_calibration/20170609/proj_01.txt');
proj_01 = fscanf(fid,'%f',[2 70])';
imagePoints(:,:,2,2) = proj_00;

fid = fopen('/Users/ama/Desktop/DfD/proj_cam_calibration/20170609/proj_02.txt');
proj_02 = fscanf(fid,'%f',[2 70])';
imagePoints(:,:,3,2) = proj_00;

fid = fopen('/Users/ama/Desktop/DfD/proj_cam_calibration/20170609/proj_03.txt');
proj_03 = fscanf(fid,'%f',[2 70])';
imagePoints(:,:,4,2) = proj_00;

fid = fopen('/Users/ama/Desktop/DfD/proj_cam_calibration/20170609/proj_04.txt');
proj_04 = fscanf(fid,'%f',[2 70])';
imagePoints(:,:,5,2) = proj_00;

fid = fopen('/Users/ama/Desktop/DfD/proj_cam_calibration/20170609/proj_05.txt');
proj_05 = fscanf(fid,'%f',[2 70])';
imagePoints(:,:,6,2) = proj_00;

fid = fopen('/Users/ama/Desktop/DfD/proj_cam_calibration/20170609/world_00.txt');
worldPoints = fscanf(fid,'%f',[2 70])';

[cameraParams,imagesUsed,estimationErrors] = estimateCameraParameters(imagePoints,worldPoints)
% F = estimateFundamentalMatrix(matchedPoints1,matchedPoints2)
