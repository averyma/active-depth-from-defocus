%Joint denoising and enhancement using Bayesian Residual Transform
%Alexander Wong - a28wong@uwaterloo.ca - University of Waterloo - 2016

close all;
% I = imread('F:\DfD\Dropbox\source\BRT2drecon\hemisphere_1_05.png');
I = imread('/Users/ama/Desktop/hemisphere_36_1x1_ff.png');
I = double(I(:,:,1))./255;

%BRT parameters
radius = 6;
regconst = 0.02; %0.02 for hand, 0.04 for ball

%BRT denoising and enhancement
cI = BRTseg(imresize(I,3),radius,regconst);
% cI = max(cI(:))-cI;
% cI(cI<0.3)=0;
figure,subplot(1,2,1);imshow(I);
subplot(1,2,2);imshow(cI,[]);
% figure,mesh(cI);
% imwrite(cI,'hemisphere_1.png');

% figure,imshow(cI,'colormap',jet)