%% limiting fov
% x direction
sparse_map_b(sparse_map_b(:,1)<750,:)=[];
sparse_map_b(sparse_map_b(:,1)>2570,:)=[];
sparse_map_r(sparse_map_r(:,1)<750,:)=[];
sparse_map_r(sparse_map_r(:,1)>2570,:)=[];
% 
% % y direction
sparse_map_b(sparse_map_b(:,2)<900,:)=[];
sparse_map_b(sparse_map_b(:,2)>1400,:)=[];
sparse_map_r(sparse_map_r(:,2)<900,:)=[];
sparse_map_r(sparse_map_r(:,2)>1400,:)=[];
% 
% % depth
% sparse_map_r(:,3) = sparse_map_r(:,3) -1.5;
% sparse_map_b(:,3) = sparse_map_b(:,3) - 1;
% 
% sparse_map_b(sparse_map_b(:,3)<37.64,:)=[];
% sparse_map_b(sparse_map_b(:,3)>46,:)=[];
% sparse_map_r(sparse_map_r(:,3)<37.64,:)=[];
% sparse_map_r(sparse_map_r(:,3)>46,:)=[];

%% median filtering
sparse_map_r_select_eye = [];
sparse_map_b_select_eye = [];
sparse_map_r_select_nose = [];
sparse_map_b_select_nose = [];
sparse_map_r_select_mouth = [];
sparse_map_b_select_mouth = [];
[pointslist,xselect,yselect] = selectdata;

%% select eye area
sparse_map_r_select_eye = cell2mat(xselect(1));
sparse_map_b_select_eye = cell2mat(xselect(2));
sparse_map_r_select_eye = [sparse_map_r_select_eye cell2mat(yselect(1))];
sparse_map_b_select_eye = [sparse_map_b_select_eye cell2mat(yselect(2))];
sparse_map_r_select_eye(:,3) = 40;
sparse_map_b_select_eye(:,3) = 40;

%% select nose area
[pointslist,xselect,yselect] = selectdata;
sparse_map_r_select_nose = cell2mat(xselect(1));
sparse_map_b_select_nose = cell2mat(xselect(2));
sparse_map_r_select_nose = [sparse_map_r_select_nose cell2mat(yselect(1))];
sparse_map_b_select_nose = [sparse_map_b_select_nose cell2mat(yselect(2))];
sparse_map_r_select_nose(:,3) = 41;
sparse_map_b_select_nose(:,3) = 41;

%% select mouse area
[pointslist,xselect,yselect] = selectdata;
sparse_map_r_select_mouth = cell2mat(xselect(1));
sparse_map_b_select_mouth = cell2mat(xselect(2));
sparse_map_r_select_mouth = [sparse_map_r_select_mouth cell2mat(yselect(1))];
sparse_map_b_select_mouth = [sparse_map_b_select_mouth cell2mat(yselect(2))];
sparse_map_r_select_mouth(:,3) = 42;
sparse_map_b_select_mouth(:,3) = 42;

sparse_map_b = [sparse_map_b_select_eye; sparse_map_b_select_nose; sparse_map_b_select_mouth];
sparse_map_r = [sparse_map_r_select_eye; sparse_map_r_select_nose; sparse_map_r_select_mouth];

figure;
hold on
plot3(sparse_map_r(:,1),sparse_map_r(:,2),sparse_map_r(:,3),'r.','markersize', 15)
plot3(sparse_map_b(:,1),sparse_map_b(:,2),sparse_map_b(:,3),'b.','markersize', 15)




sparse_map_b(:,3) = sparse_map_b(:,3) - 0.8;
sparse_map_b(sparse_map_b(:,3)>43,:) = [];
sparse_map_r(sparse_map_r(:,3)>43,:) = [];


figure;
hold on
plot3(sparse_map_r(:,1),sparse_map_r(:,2),sparse_map_r(:,3),'r.','markersize', 15)
plot3(sparse_map_b(:,1),sparse_map_b(:,2),sparse_map_b(:,3),'b.','markersize', 15)

sparse_map_r(sparse_map_r(:,1)>1000 & sparse_map_r(:,1)<1400 & sparse_map_r(:,2)>700 & sparse_map_r(:,2)<1100,3) = 43;



[sparse_map_r_median] = medianFilter(sparse_map_r,5);
[sparse_map_b_median] = medianFilter(sparse_map_b,5);
% [sparse_map_r_median,sparse_map_b_median] = medianFilter(sparse_map_r,sparse_map_b,10);


sparse_map = [sparse_map_b; sparse_map_r];
[sparse_map_median] = medianFilter(sparse_map, 3);
figure;
hold on
plot3(sparse_map_median(:,1),sparse_map_median(:,2),sparse_map_median(:,3),'r.','markersize', 15)

%% plotting
figure;
hold on
plot3(sparse_map_r_median(:,1),sparse_map_r_median(:,2),sparse_map_r_median(:,3),'r.','markersize', 15)
plot3(sparse_map_b_median(:,1),sparse_map_b_median(:,2),sparse_map_b_median(:,3),'b.','markersize', 15)


sparse_map_r_median(:,1)=max(sparse_map_r_median(:,1))-sparse_map_r_median(:,1);
sparse_map_r_median(:,2)=max(sparse_map_r_median(:,2))-sparse_map_r_median(:,2);
sparse_map_b_median(:,1)=max(sparse_map_b_median(:,1))-sparse_map_b_median(:,1);
sparse_map_b_median(:,2)=max(sparse_map_b_median(:,2))-sparse_map_b_median(:,2);



plot3(sparse_map_r_median(:,3),sparse_map_r_median(:,1),sparse_map_r_median(:,2),'r.','markersize', 15)
plot3(sparse_map_b_median(:,3),sparse_map_b_median(:,1),sparse_map_b_median(:,2),'b.','markersize', 15)

% spacing = 15;
% staircase_h = [324 2024];
% staircase_w = [818+1 2501-1];
% [X,Y] = meshgrid(staircase_w(1):spacing:staircase_w(2),...
%                  staircase_h(1):spacing:staircase_h(2));
% trueDepth = 44.*(heaviside( 911-X) - heaviside( 818-X))+...818 911
%             43.*(heaviside(1012-X) - heaviside( 911-X))+...1012
%             42.*(heaviside(1117-X) - heaviside(1012-X))+...1117
%             41.*(heaviside(1226-X) - heaviside(1117-X))+...1226
%             40.*(heaviside(1344-X) - heaviside(1226-X))+...1344
%             39.*(heaviside(1426-X) - heaviside(1344-X))+...1426
%             38.*(heaviside(1726-X) - heaviside(1426-X))+...1726
%             39.*(heaviside(1855-X) - heaviside(1726-X))+...1855  
%             40.*(heaviside(1976-X) - heaviside(1855-X))+...1976
%             41.*(heaviside(2090-X) - heaviside(1976-X))+...2090
%             42.*(heaviside(2201-X) - heaviside(2090-X))+...2201
%             43.*(heaviside(2302-X) - heaviside(2201-X))+...2302
%             44.*(heaviside(2401-X) - heaviside(2302-X))+...2401
%             45.*(heaviside(2501-X) - heaviside(2401-X));
% mesh(X,Y,trueDepth,'linewidth',2)
% alpha(0)
grid on
xlabel('Depth (cm)');ylabel('x (pixel)');zlabel('y (pixel)')
legend('Estimated Depth (red)','Estimated Depth (blue)')
title('Ground Truth Depth vs. Estimated Depth')

axis([1250 1950 900 1400 36 50])
% axis([750 2570 900 1400 37 47])
axis([38 46 70 1500 900 1400])
