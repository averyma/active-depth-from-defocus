% I_depth_map = [sparse_map_r_median; sparse_map_b_median];
clc
clear
load /Users/ama/Desktop/DfD/result/cnn/sparse_map_staircase_0130.mat
I_depth_map = sparse_map_median;
numb_of_pt = length(I_depth_map);

%% creating a n x 2 chart (estimated_depth,true_depth) to calculate RMSE
I_rmse = zeros(numb_of_pt,2);
k = 1;
for i = 1:numb_of_pt
   I_rmse(k,1) = I_depth_map(i,3);
   X = I_depth_map(i,1);
   I_rmse(k,2) = 42.*(heaviside(1135-X) - heaviside(1000-X))+...
                 41.*(heaviside(1244-X) - heaviside(1135-X))+...1012
                 40.*(heaviside(1360-X) - heaviside(1244-X))+...1117
                 39.*(heaviside(1470-X) - heaviside(1360-X))+...1226
                 38.*(heaviside(1740-X) - heaviside(1470-X))+...1344
                 39.*(heaviside(1866-X) - heaviside(1740-X))+...1426
                 40.*(heaviside(1987-X) - heaviside(1866-X))+...1726
                 41.*(heaviside(2096-X) - heaviside(1987-X))+...1855  
                 42.*(heaviside(2210-X) - heaviside(2096-X));
   k =k+1;
end

% rmse
rmse = sqrt(mean((I_rmse(:,1)-I_rmse(:,2)).^2))

% correlation coefficient
R = corrcoef(I_rmse(:,1),I_rmse(:,2))


% I_rmse(round(I_rmse(:,1))==42 & I_rmse(:,2)==45,:)=[];

figure;
plot(I_rmse(:,1),I_rmse(:,2),'r.','markersize',20)
xlabel('Estimated Depth (cm)')
ylabel('Groud Truth Depth (cm)')
grid on
title('Estimated Depth vs. Ground Truth Depth')

%% calculation for correlation coefficient
r = 0;
n = length(I_rmse);
mu = mean(I_rmse(:,1));
mu_hat = mean(I_rmse(:,2));
var = sqrt(cov(I_rmse(:,1)));
var_hat = sqrt(cov(I_rmse(:,2)));
for i = 1:n
    y = I_rmse(i,1);
    y_hat = I_rmse(i,2);
    r = r + 1/(n-1)*((y-mu)*(y_hat-mu_hat)/(var*var_hat));
end
r
