close all
clear
clc
%% 20160826 data
% data = [30 29.97698333;
%         35 23.76818333;
%         40 18.5825;
%         45 14.70576667;
%         50 11.29136667;
%         55 8.787;
%         60 6.569666667;
%         65 4.71125;];
% 
% curve = fit(data(:,1),data(:,2),'poly3')
% figure; plot(curve,data(:,1),data(:,2))

%% 20160909 data

data = zeros(8,5);
data = [30 34.7272 33.2088 32.7106
        35 27.5095 28.0225 26.0535
        40 21.5928 21.4923 21.3493
        45 18.1436 17.9549 18.5787
        50 14.8473 14.8615 13.4719
        55 11.5685 10.1393 10.9701
        60  8.6803  8.7914  7.6472
        65  6.5698  6.2922  6.0403];

data(:,5) = mean([data(:,2) data(:,3) data(:,4)],2);
curve = fit(data(:,5),data(:,1),'poly3')
figure; 
plot(curve)
hold on;
plot(data(:,5),data(:,1),'b.','MarkerSize',20)
xlabel('Standard Deviation (\sigma)'); ylabel('Depth (cm)');
title('Standard Deviation vs. Depth')
legend('Curve Fit Result','Measurement')
grid on
