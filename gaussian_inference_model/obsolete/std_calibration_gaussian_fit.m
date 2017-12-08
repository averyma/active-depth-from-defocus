clc
close all
clear

%% load cropped blurry dots
% I = im2double(imread('30cm_top_left_b.png'));
% I = im2double(imread('30cm_top_right_b.png'));
% I = im2double(imread('30cm_middle_b.png'));
% I = im2double(imread('30cm_bottom_left_b.png'));
I = im2double(imread('30cm_bottom_right_b.png'));
I = I(:,:,3);
% I(1,:) = []; I(end,:) = []; I(:,1) = []; I(:,end) = [];
% figure, imshow(I, [])

%% smooth the blur dot using averaging filter
% H = fspecial('average',[5 5]);
% I = imfilter(I,H,'replicate');

%% xData & yData for lsqcurvefit function
[n,m] = size(I);
[X,Y] = meshgrid(1:m,1:n);%your x-y coordinates
xData(:,1) = X(:); % x= first column
xData(:,2) = Y(:); % y= second column
yData = I(:); % your data f(x,y) (in column vector)


%% lsqcurvefit 
 
% gau2D_fun = @(gau2D,xData) 1/(2*pi*gau2D(1)^2)*...
%                                 exp(-((xData(:,1)-gau2D(2)).^2+(xData(:,2)-gau2D(3)).^2)/(2*gau2D(1)^2));

gau2D_fun = @(gau2D,xData) gau2D(1) + gau2D(2)*...
                                exp(-((xData(:,1)-gau2D(3)).^2/(2*gau2D(5)^2)+...
                                      (xData(:,2)-gau2D(4)).^2/(2*gau2D(6)^2)));

options = optimset('TolX',1e-6);
gau2D = [0 10 round(n/2) round(m/2) 10 10]; % offset, A, mean_x, mean_y, std_x, std_y 
gau2D_fit = lsqcurvefit(gau2D_fun,gau2D,xData,yData,[],[],options);
gau2D_fit = abs(gau2D_fit)
I_fit = gau2D_fun(gau2D_fit,xData); 
I_fit = reshape(I_fit,[n m]); 

std_avg = mean([gau2D_fit(5) gau2D_fit(6)])

%% plot
figure 
hold on
surf(X,Y,I)
surf(X,Y,-I_fit)

% % gaussian estimate
% figure;
% surf(X,Y,I*10000)
% axis([30 75 30 75])
% grid on
% xlabel('x')
% ylabel('y')
% zlabel('Intensity * 10000')
% title('Gaussian Estimation using Maximum Likelihood')

