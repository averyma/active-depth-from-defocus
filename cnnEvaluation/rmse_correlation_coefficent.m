I_depth_map = sparse_map_median_seq2;
numb_of_pt = length(I_depth_map);
 
%% creating a n x 2 chart (estimated_depth,true_depth) to calculate RMSE
I_rmse = zeros(numb_of_pt,2);
k = 1;
for i = 1:numb_of_pt
   I_rmse(k,1) = I_depth_map(i,3);
   X = I_depth_map(i,1);
%    I_rmse(k,2) = 400.*(heaviside(1113-X) - heaviside(996-X))+...
%             395.*(heaviside(1233-X) - heaviside(1113-X))+...1012
%             390.*(heaviside(1356-X) - heaviside(1233-X))+...1117
%             385.*(heaviside(1479-X) - heaviside(1356-X))+...1226
%             380.*(heaviside(1740-X) - heaviside(1479-X))+...1344
%             385.*(heaviside(1866-X) - heaviside(1740-X))+...1426
%             390.*(heaviside(1987-X) - heaviside(1866-X))+...1726
%             395.*(heaviside(2112-X) - heaviside(1987-X))+...1855  
%             400.*(heaviside(2229-X) - heaviside(2112-X))+...
%             405.*(heaviside(2343-X) - heaviside(2229-X));

I_rmse(k,2) = 420.*(heaviside(1137-X) - heaviside(1000-X))+...
            410.*(heaviside(1245-X) - heaviside(1137-X))+...1012
            400.*(heaviside(1359-X) - heaviside(1245-X))+...1117
            390.*(heaviside(1479-X) - heaviside(1359-X))+...1226
            380.*(heaviside(1740-X) - heaviside(1479-X))+...1344
            390.*(heaviside(1863-X) - heaviside(1740-X))+...1426
            400.*(heaviside(1977-X) - heaviside(1863-X))+...1726
            410.*(heaviside(2094-X) - heaviside(1977-X))+...1855  
            420.*(heaviside(2199-X) - heaviside(2094-X))+...
            430.*(heaviside(2400-X) - heaviside(2199-X));

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
% r = 0;
% n = length(I_rmse);
% mu = mean(I_rmse(:,1));
% mu_hat = mean(I_rmse(:,2)); 
% var = sqrt(cov(I_rmse(:,1)));
% var_hat = sqrt(cov(I_rmse(:,2)));
% for i = 1:n
%     y = I_rmse(i,1); 
%     y_hat = I_rmse(i,2);
%     r = r + 1/(n-1)*((y-mu)*(y_hat-mu_hat)/(var*var_hat));
% end


