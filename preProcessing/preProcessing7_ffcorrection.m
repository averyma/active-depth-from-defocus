clc
clear
close all

file = 'b_42';
path = ['/Users/ama/Desktop/DfD/ScreenCap/cnn/20170721ScreenCap/' file '/'];



r = im2double(imread([path file '_1.png']));

d1 = im2double(imread([path file '_d1.png']));
d2 = im2double(imread([path file '_d2.png']));
d3 = im2double(imread([path file '_d3.png']));

d = (d1+d2+d3)./3;

w1 = im2double(imread([path file '_w1.png']));
w2 = im2double(imread([path file '_w2.png']));
w3 = im2double(imread([path file '_w3.png']));

w = (w1+w2+w3)./3;

c = (r-d)./(w-d);
figure;imshow(r)
figure;imshow(c)

imwrite(c,[path file '_corrected.png'])



