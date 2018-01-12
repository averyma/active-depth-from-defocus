folder = '/Users/ama/Desktop/DfD/Dropbox/source/r415/';
files = dir([folder '*.png']);

d1 = im2double(imread([folder files(5).name]));
d2 = im2double(imread([folder files(6).name]));
d3 = im2double(imread([folder files(7).name]));
f1 = im2double(imread([folder files(8).name]));
f2 = im2double(imread([folder files(9).name]));
f3 = im2double(imread([folder files(10).name]));
d = (d1+d2+d3)./3;
f = (f1+f2+f3)./3;

channel_threshold = 170;
r = im2double(imread([folder files(1).name]));
img_ff = (r-d)./(f-d);
img = img_ff(:,:,1);
img_threshold = img;
img_threshold(img_threshold(:,:)<(channel_threshold/255)) = 0;
lvl = graythresh(img_threshold);
img_otsu = img_threshold > lvl;
figure;imshow(img_otsu)