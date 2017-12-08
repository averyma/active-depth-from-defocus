load sparse_map.mat

figure;
hold on
plot3(sparse_map_r(:,1),sparse_map_r(:,2),sparse_map_r(:,3),'r.','markersize', 10)
plot3(sparse_map_b(:,1),sparse_map_b(:,2),sparse_map_b(:,3)+0.5,'b.','markersize', 10)

spacing = 5;
staircase_h = [324 2024];
staircase_w = [822+1 2496-1];
[X,Y] = meshgrid(staircase_w(1):spacing:staircase_w(2),...
                 staircase_h(1):spacing:staircase_h(2));
trueDepth = 44.*(heaviside( 915-X) - heaviside( 822-X))+...
            43.*(heaviside(1012-X) - heaviside( 915-X))+...1012
            42.*(heaviside(1117-X) - heaviside(1012-X))+...1117
            41.*(heaviside(1226-X) - heaviside(1117-X))+...1226
            40.*(heaviside(1344-X) - heaviside(1226-X))+...1344
            39.*(heaviside(1426-X) - heaviside(1344-X))+...1426
            38.*(heaviside(1726-X) - heaviside(1426-X))+...1726
            39.*(heaviside(1855-X) - heaviside(1726-X))+...1855  
            40.*(heaviside(1976-X) - heaviside(1855-X))+...1976
            41.*(heaviside(2090-X) - heaviside(1976-X))+...2090
            42.*(heaviside(2201-X) - heaviside(2090-X))+...2201
            43.*(heaviside(2302-X) - heaviside(2201-X))+...2302
            44.*(heaviside(2401-X) - heaviside(2302-X))+...2401
            45.*(heaviside(2497-X) - heaviside(2401-X));
mesh(X,Y,trueDepth,'linewidth',1)
alpha(0)
grid on
xlabel('x (pixel)');ylabel('y (pixel)');zlabel('Depth (cm)')
legend('Ground Truth Depth','Estimated Depth')
title('Ground Truth Depth vs. Estimated Depth')