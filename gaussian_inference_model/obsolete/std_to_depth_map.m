close all
clear
clc

% curve = 
% 
%      Linear model Poly3:
%      curve(x) = p1*x^3 + p2*x^2 + p3*x + p4
%      Coefficients (with 95% confidence bounds):
%       p1 =  -0.0005605;  
%       p2 =     0.06057;  
%       p3 =      -2.916 ;  
%       p4 =        80.78;


%%
load I_std_map_20160909_triangle_0.05.mat

p1 =  -0.0005605;  
p2 =     0.06057;  
p3 =      -2.916 ;  
p4 =        80.78;

std2depth = @(std) p1.*std.^3 + p2.*std.^2 + p3.*std + p4;

I_std_map(I_std_map==0) = NaN;
I_depth_map = std2depth(I_std_map);

[n,m] = size(I_std_map);
[X,Y] = meshgrid(1:m,1:n);

% figure for estimated depth
figure;
plot3(X,Y,I_depth_map,'r.','markersize', 20)
grid on

% figure for Ground Truth depth vs Estimated Depth
figure;
spacing = 50;
[X_p,Y_p] = meshgrid(1:spacing:m,1:spacing:n); % X_p, Y_p for mesh plotting purpose
trueDepth = (-9/662*X_p+59+2).*heaviside(662-X_p)+...
            (6/618*X_p+43.57+2).*(heaviside(X_p)-heaviside(662-X_p));
mesh(X_p,Y_p,trueDepth,'linewidth',1) 
% PS: to avoid slow run time, plot as line with 1 first then change to 5
alpha(0)
hold on
plot3(X,Y,I_depth_map,'r.','markersize', 30)
grid on
xlabel('x (pixel)');ylabel('y (pixel)');zlabel('Depth (cm)')
legend('Ground Truth Depth','Estimated Depth')
title('Ground Truth Depth vs. Estimated Depth')
