%2D Gaussian modeling
%Alexander Wong (a28wong@uwaterloo.ca), University of Waterloo, 2016
% clc;
% im = fspecial('gaussian',[201 201],30);
im = imread('/Users/ama/Desktop/DfD/hmm/train_red_150.png');
im = double(im);

im = im-min(im(:));
im = im./max(im(:));
im = im-0.15;
im(im<0) = 0;
im = im./max(im(:));
figure,imshow(im,[]);

[x y]=meshgrid([1:size(im,1)],[1:size(im,2)]);
im = round(im*10000);

sampleconfig = [x(:) y(:) im(:)];

sampleset = zeros(sum(sampleconfig(:,3)),2);
count = 1;
for i = 1:size(sampleconfig,1)
    if sampleconfig(i,3)~=0
        sampleset(count:count+sampleconfig(i,3)-1,:) = repmat(sampleconfig(i,1:2),[sampleconfig(i,3) 1]);
        count = count+sampleconfig(i,3);
    end;
end;

a = cov(sampleset)