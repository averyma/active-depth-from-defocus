%% preProcessing using existing calibration images and extrinsics
% 
%  * Calibrate camera [1600x1200]
%  * Calibrate projector [640x720]
%  * Calibrate stereo
% 
%  **** Calibration results ****
% 
% Camera Calib: 
%  - reprojection error: 0.246274
%  - K:
% [1313.363039808764, 0, 794.3410746908803;
%   0, 1319.142345777889, 589.8123353762453;
%   0, 0, 1]
%  - kc: [0.07028634430153954, -0.2486468774268904, 5.623079393017704e-05, 0.004003609187888305, 0]
% 
% Projector Calib: 
%  - reprojection error: 0.187653
%  - K:
% [1174.879267290042, 0, 303.5937929734781;
%   0, 2347.335839219325, 768.4167887524895;
%   0, 0, 1]
%  - kc: [-0.08317255288184269, -0.03151568245531312, 0.0002783034719784698, -0.002519912916869566, 0]
% 
% Stereo Calib: 
%  - reprojection error: 0.226949
%  - R:
% [0.9236321287566447, 0.03024839233329489, -0.3820847098350311;
%   -0.08967415759803175, 0.9862669296115971, -0.1386942284797615;
%   0.3726422361831147, 0.1623655699825674, 0.9136603228206224]
%  - T:
% [158.7283106875177;
%   -59.10932269621188;
%   306.1533836158169]
%%
i = imread('/Users/ama/Desktop/DfD/proj_cam_calibration/cartman/2013-May-14_20.44.06.773/cam_07.png');
i = rgb2gray(i);
figure;imshow(i)

f = 100;
[x,y] = meshgrid(-600:f:600-f,-800:f:800-f);
z = zeros(size(x));

p = [reshape(x,[1 size(x,1)*size(x,2)]);
     reshape(z,[1 size(z,1)*size(z,2)]);
     reshape(y,[1 size(y,1)*size(y,2)]);];
figure;plot3(p(1,:),p(2,:),p(3,:),'r.')
grid on

R = [0.9236321287566447,  0.03024839233329489, -0.3820847098350311;
    -0.08967415759803175, 0.9862669296115971,  -0.1386942284797615;
     0.3726422361831147,  0.1623655699825674,   0.9136603228206224];
T = [158.7283106875177;
     -59.10932269621188;
     306.1533836158169];

pp = (p'*R)'+T;
hold on;plot3(pp(1,:),pp(2,:),pp(3,:),'b.')

