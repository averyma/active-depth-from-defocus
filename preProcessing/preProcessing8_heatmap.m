clear
clc
iptsetpref('ImshowBorder','tight');
% close all

warning off
load('/Users/ama/Desktop/DfD/20170802_hemisphere_sparse_map.mat')

figure;
hold on
plot3(sparse_map_median_rb(:,1),sparse_map_median_rb(:,2),sparse_map_median_rb(:,3),'r.','markersize', 10)
% plot3(sparse_map_median_rb(:,3),sparse_map_median_rb(:,1),max(sparse_map_median_rb(:,2))-sparse_map_median_rb(:,2),'r.','markersize', 10)
title('sparse map')
legend('Estimated depth(median filter)')
xlabel('x (pixel)');ylabel('y (pixel)');zlabel('Depth(mm)')
grid on

% heat_map = zeros(2448,3264);
% tic
% for i = 1:length(sparse_map_median_rb)
%     heat_map(sparse_map_median_rb(i,2),sparse_map_median_rb(i,1)) = sparse_map_median_rb(i,3);
% end
% toc
% figure;imshow(heat_map);hold on
% 
% min_x = min(sparse_map_median_rb(:,1)); min_y = min(sparse_map_median_rb(:,2));
% max_x = max(sparse_map_median_rb(:,1)); max_y = max(sparse_map_median_rb(:,2)); 
% 
% plot(min_x,min_y,'r.','MarkerSize',30)
% plot(min_x,max_y,'b.','MarkerSize',30)
% plot(max_x,min_y,'g.','MarkerSize',30)
% plot(max_x,max_y,'y.','MarkerSize',30)

% for k = min_x:max_x
%     (k-min_x)/(max_x-min_x)
%     for j = min_y:max_y
% %         plot(k,j,'r.')
%         if heat_map(j,k) ==0
%             
%             [d,idx] = pdist2(sparse_map_median_rb(:,1:2),[k,j],'euclidean','Smallest',5);   
% %         if d >20
% %             break
% %         end
% %             plot(sparse_map_median_rb(idx,1),sparse_map_median_rb(idx,2),'b.')
%             
%             if d<10
%             heat_map(j,k) = median([sparse_map_median_rb(idx(1),3),...
%                                     sparse_map_median_rb(idx(2),3),...
%                                     sparse_map_median_rb(idx(3),3),...
%                                     sparse_map_median_rb(idx(4),3),...
%                                     sparse_map_median_rb(idx(5),3)]);
%         
%             end
%         end
%     end
% end
% 
% heat_map(heat_map ==0) = 100
% heat_map(heat_map ==10)
% heat_map = heat_map(min_y:max_y,min_x:max_x
% figure;imshow(heat_map)


sparse_surf = sparse_map_median_rb;
[xq,yq] = meshgrid(min(sparse_surf(:,1)):max(sparse_surf(:,1)),...
                      min(sparse_surf(:,2)):max(sparse_surf(:,2)));

f = 1;
zq = griddata(sparse_surf(:,1),sparse_surf(:,2),sparse_surf(:,3),...
              xq(1:f:end,1:f:end),yq(1:f:end,1:f:end));
zq(isnan(zq)) = max(sparse_surf(:,3));
figure;imshow(zq,[])

avg_filter_size = 7;
pad_size = (avg_filter_size+1)/2;
zq = padarray(zq,[pad_size pad_size],'replicate');
zq = conv2(zq,fspecial('average',avg_filter_size),'same');
zq = zq(pad_size+1:end-pad_size,pad_size+1:end-pad_size);

figure;
surf(xq(1:f:end,1:f:end),max(yq(:))-yq(1:f:end,1:f:end),zq);
title('surface fit with griddata')
xlabel('x (pixel)');ylabel('y (pixel)');zlabel('Depth(mm)')